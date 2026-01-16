import Foundation
import simd
import Combine

struct InversionParticle {
    var pos: SIMD3<Float>
    var vel: SIMD3<Float>
    var life: Float
}

final class InversionSimulation: ObservableObject {
    // Inputs
    @Published var timeOfDay: Float = 18 // 0..24
    @Published var windSpeed: Float = 1.5 // m/s
    @Published var windDirectionDeg: Float = 0 // 0..360
    @Published var emissions: Float = 0.5 // 0..1
    @Published var autoInversion: Bool = true
    @Published var capHeight: Float = 1.2 // meters

    // Outputs
    @Published private(set) var aqi: Int = 50
    @Published private(set) var aqiCategory: String = "Good"

    // Particle pool
    private(set) var particles: [InversionParticle] = []
    private var poolCount: Int
    private var lastEmitCarry: Float = 0

    // Bounds
    let domainHalfSize: Float = 1.5 // +/- X,Z
    let groundY: Float = 0.02

    init(particleCount: Int = 500) {
        poolCount = max(100, min(particleCount, 2000))
        particles = (0..<poolCount).map { _ in
            InversionParticle(pos: SIMD3(0, groundY + Float.random(in: 0...0.3), 0),
                              vel: SIMD3.zero,
                              life: 0)
        }
    }

    func setAutoCapHeight() {
        guard autoInversion else { return }
        // Simple diurnal: strong inversion at night, weak daytime
        // Map time to strength: peak at 5am, forming from 6pm
        let t = timeOfDay/24
        let nightFactor: Float = {
            // two triangles: 18-24 up, 0-9 down
            if timeOfDay >= 18 { return min((timeOfDay-18)/6, 1) }
            if timeOfDay <= 9 { return max(1 - timeOfDay/9, 0) }
            return 0
        }()
        // Lower cap when stronger inversion
        capHeight = 0.6 + (1.6 - 0.6) * (1 - nightFactor)
    }

    func update(dt: Float) {
        if autoInversion { setAutoCapHeight() }

        // Emissions per second scaled by slider and time of day (rush hours)
        var rate = 60 * emissions // base
        if timeOfDay >= 7 && timeOfDay <= 9 { rate *= 1.6 }
        if timeOfDay >= 17 && timeOfDay <= 19 { rate *= 1.8 }
        emit(ratePerSec: rate, dt: dt)

        let wind = windVector()
        let mixFactor = mixingFactor()
        let turb: Float = 0.6 * mixFactor

        for i in particles.indices {
            guard particles[i].life > 0 else { continue }
            // Advection
            particles[i].vel.x += wind.x * dt
            particles[i].vel.z += wind.z * dt

            // Weak vertical motion suppressed by inversion
            let vTurb = SIMD3<Float>(
                Float.random(in: -turb...turb),
                Float.random(in: -turb...turb) * 0.25,
                Float.random(in: -turb...turb)
            )
            particles[i].vel += vTurb * 0.5 * dt
            particles[i].pos += particles[i].vel * dt

            // Cap reflection
            if particles[i].pos.y > capHeight {
                particles[i].pos.y = capHeight
                particles[i].vel.y *= -0.4
            }
            // Ground bounce
            if particles[i].pos.y < groundY {
                particles[i].pos.y = groundY
                particles[i].vel.y = abs(particles[i].vel.y) * 0.2
            }
            // Domain wrap XZ
            if particles[i].pos.x > domainHalfSize { particles[i].pos.x = -domainHalfSize }
            if particles[i].pos.x < -domainHalfSize { particles[i].pos.x = domainHalfSize }
            if particles[i].pos.z > domainHalfSize { particles[i].pos.z = -domainHalfSize }
            if particles[i].pos.z < -domainHalfSize { particles[i].pos.z = domainHalfSize }

            particles[i].life -= 0.04 * dt
        }

        recomputeAQI()
    }

    private func windVector() -> SIMD3<Float> {
        let rad = windDirectionDeg * .pi / 180
        return SIMD3(cos(rad) * windSpeed, 0, sin(rad) * windSpeed)
    }

    private func mixingFactor() -> Float {
        // 0.1 (strong inversion) .. 1.0 (well mixed) based on cap height
        let t = (capHeight - 0.6) / (1.6 - 0.6)
        return max(0.1, min(1.0, t))
    }

    private func emit(ratePerSec: Float, dt: Float) {
        let desired = ratePerSec * dt + lastEmitCarry
        var n = Int(desired)
        lastEmitCarry = desired - Float(n)
        if n == 0 { return }
        // Fill dead particles
        for i in particles.indices where n > 0 {
            if particles[i].life <= 0 {
                particles[i].life = 1
                particles[i].pos = SIMD3(Float.random(in: -0.2...0.2), groundY + 0.05, Float.random(in: -0.2...0.2))
                particles[i].vel = SIMD3(Float.random(in: -0.1...0.1), Float.random(in: 0.0...0.2), Float.random(in: -0.1...0.1))
                n -= 1
            }
        }
    }

    private func recomputeAQI() {
        // Simple box model: concentration proportional to active particles below cap / (mix height * wind)
        let active = particles.filter { $0.life > 0 && $0.pos.y <= capHeight }.count
        let mixH = max(capHeight - groundY, 0.2)
        let ventilation = max(mixH * (0.5 + windSpeed), 0.2)
        let conc = Float(active) / ventilation
        // Map to approximate PM2.5 then AQI
        let pm = min(max(conc * 0.08, 0), 300)
        let aqiVal = pmToAQI(Double(pm))
        aqi = Int(aqiVal.rounded())
        aqiCategory = category(for: aqi)
    }

    private func pmToAQI(_ pm: Double) -> Double {
        // EPA AQI breakpoints for PM2.5 (24-hr) simplified mapping
        let bp: [(Double, Double, Int, Int)] = [
            (0.0, 12.0, 0, 50),
            (12.1, 35.4, 51, 100),
            (35.5, 55.4, 101, 150),
            (55.5, 150.4, 151, 200),
            (150.5, 250.4, 201, 300),
            (250.5, 500.4, 301, 500)
        ]
        for (cl, ch, il, ih) in bp {
            if pm >= cl && pm <= ch {
                return Double(il) + (pm - cl) * Double(ih - il) / (ch - cl)
            }
        }
        return 500
    }

    private func category(for aqi: Int) -> String {
        switch aqi {
        case ..<51: return "Good"
        case 51..<101: return "Moderate"
        case 101..<151: return "USG"
        case 151..<201: return "Unhealthy"
        case 201..<301: return "Very Unhealthy"
        default: return "Hazardous"
        }
    }
}

