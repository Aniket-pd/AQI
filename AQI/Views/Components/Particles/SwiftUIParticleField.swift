import SwiftUI

struct SwiftUIParticleField: View {
    var mood: AQIParticleMood
    var cornerRadius: CGFloat
    var trigger: UUID
    // Active motion duration before beginning global fade-out.
    // Total visible time ≈ activeDuration + fadeOutWindow.
    var activeDuration: TimeInterval = 2.2
    // Length of the global fade after active motion completes.
    var fadeOutWindow: TimeInterval = 0.5

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var particles: [Particle] = []
    @State private var startedAt: Date? = nil
    @State private var lastStep: Date? = nil
    @State private var pulseOpacity: Double = 0

    private let spawnWindow: TimeInterval = 0.36

    var body: some View {
        GeometryReader { geo in
            ZStack {
                TimelineView(.animation) { timeline in
                    Canvas(rendersAsynchronously: true) { ctx, size in
                        guard !particles.isEmpty, let startedAt else { return }
                        let now = timeline.date
                        let dt = (lastStep.map { now.timeIntervalSince($0) } ?? 0.016)
                        let elapsed = now.timeIntervalSince(startedAt)

                        // Update physics and draw
                        var newParticles: [Particle] = []
                        newParticles.reserveCapacity(particles.count)
                        // Global envelope for graceful disappearance after active motion
                        let fadeStart = max(0, activeDuration)
                        let g: Double
                        if elapsed <= fadeStart { g = 1.0 }
                        else {
                            let t = min(1.0, max(0.0, (elapsed - fadeStart) / fadeOutWindow))
                            // smoothstep(1 - t)
                            let s = t * t * (3 - 2 * t)
                            g = 1.0 - s
                        }

                        for var p in particles {
                            // Integrate simple drift
                            p.vx += mood.xAcceleration * 0.003
                            p.vy += mood.yAcceleration * 0.003
                            p.x += p.vx * dt
                            p.y += p.vy * dt
                            p.age += dt

                            // Respect spawn delay for organic appearance
                            let activeAge = p.age - p.spawnDelay
                            if activeAge < 0 { continue }

                            // Keep inside bounds: bounce softly
                            if p.x < 0 { p.x = 0; p.vx = abs(p.vx) * 0.6 }
                            if p.x > size.width { p.x = size.width; p.vx = -abs(p.vx) * 0.6 }
                            if p.y < 0 { p.y = 0; p.vy = abs(p.vy) * 0.6 }
                            if p.y > size.height { p.y = size.height; p.vy = -abs(p.vy) * 0.6 }

                            // Per-particle fade in/out for natural feel
                            let fin = min(1.0, max(0.0, activeAge / p.fadeIn))
                            let finEase = fin * fin * (3 - 2 * fin) // smoothstep
                            let life = max(0.0, 1.0 - activeAge / p.lifetime)
                            let alpha = CGFloat(p.baseAlpha) * CGFloat(finEase) * CGFloat(life) * CGFloat(g)
                            if alpha > 0.01 {
                                newParticles.append(p)
                                let scaleEase = max(0.35, finEase)
                                let radius = max(1.0, p.scale * scaleEase)
                                let rect = CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)
                                let color = Color(uiColor: mood.color).opacity(alpha)
                                ctx.fill(Path(ellipseIn: rect), with: .color(color))
                            }
                        }

                        particles = newParticles
                        lastStep = now
                    }
                }
                // Reduce Motion fallback pulse overlay
                Color.white.opacity(pulseOpacity)
                    .animation(.easeInOut(duration: 0.6), value: pulseOpacity)
            }
            .onChange(of: trigger) { _ in
                if reduceMotion {
                    // Brief luminance pulse
                    particles.removeAll()
                    startedAt = nil
                    lastStep = nil
                    pulseOpacity = 0.16
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        pulseOpacity = 0
                    }
                } else {
                    startBurst(size: geo.size)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .compositingGroup()
        .blendMode(.plusLighter)
        .allowsHitTesting(false)
    }

    private func startBurst(size: CGSize) {
        let count = particleCount(for: mood)
        var new: [Particle] = []
        new.reserveCapacity(count)
        let minLifetime = activeDuration + fadeOutWindow

        for _ in 0..<count {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: max(8, mood.velocity - 10)...(mood.velocity + 10)) * 0.2
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed
            // Ensure particles persist through the active motion window so the
            // field "keeps floating" until the global fade starts.
            let baseMin = max(1.1, Double(mood.lifetime))
            let lifetime = max(minLifetime, Double.random(in: baseMin...(Double(mood.lifetime) + 0.6)))
            let scale = CGFloat.random(in: 1.0...(2.0 + mood.scale))
            let spawnDelay = Double.random(in: 0...spawnWindow)
            let fadeIn = Double.random(in: 0.18...0.28)
            let fadeOut = Double.random(in: 0.28...0.4) // reserved for potential per-particle tail
            let baseAlpha = Double.random(in: 0.45...0.75)
            new.append(Particle(x: x, y: y, vx: vx, vy: vy, lifetime: lifetime, age: 0, scale: scale, spawnDelay: spawnDelay, fadeIn: fadeIn, fadeOut: fadeOut, baseAlpha: baseAlpha))
        }

        particles = new
        startedAt = Date()
        lastStep = startedAt
    }

    private func particleCount(for mood: AQIParticleMood) -> Int {
        // Map mood.birthRate to a reasonable short-lived particle count
        // Keep battery friendly; cap at ~180
        let base = Int(mood.birthRate)
        return min(max(20, base), 180)
    }
}

private struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    var lifetime: Double
    var age: Double
    var scale: CGFloat
    var spawnDelay: Double
    var fadeIn: Double
    var fadeOut: Double
    var baseAlpha: Double
}
