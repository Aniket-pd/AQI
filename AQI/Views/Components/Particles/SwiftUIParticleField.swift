import SwiftUI

struct SwiftUIParticleField: View {
    var mood: AQIParticleMood
    var cornerRadius: CGFloat
    var trigger: UUID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var particles: [Particle] = []
    @State private var startedAt: Date? = nil
    @State private var lastStep: Date? = nil
    @State private var pulseOpacity: Double = 0

    private let duration: TimeInterval = 1.0

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
                        let alphaFalloff = max(0.0, 1.0 - elapsed / duration)

                        for var p in particles {
                            // Integrate simple drift
                            p.vx += mood.xAcceleration * 0.003
                            p.vy += mood.yAcceleration * 0.003
                            p.x += p.vx * dt
                            p.y += p.vy * dt
                            p.age += dt

                            // Keep inside bounds: bounce softly
                            if p.x < 0 { p.x = 0; p.vx = abs(p.vx) * 0.6 }
                            if p.x > size.width { p.x = size.width; p.vx = -abs(p.vx) * 0.6 }
                            if p.y < 0 { p.y = 0; p.vy = abs(p.vy) * 0.6 }
                            if p.y > size.height { p.y = size.height; p.vy = -abs(p.vy) * 0.6 }

                            // Fade based on age and global alpha falloff
                            let baseAlpha: CGFloat = CGFloat(0.6) * CGFloat(alphaFalloff)
                            let alpha = max(0, baseAlpha - CGFloat(p.age / p.lifetime))
                            if alpha > 0.01 {
                                newParticles.append(p)
                                let radius = max(1.0, p.scale)
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
                    .animation(.easeInOut(duration: 0.45), value: pulseOpacity)
            }
            .onChange(of: trigger) { _ in
                if reduceMotion {
                    // Brief luminance pulse
                    particles.removeAll()
                    startedAt = nil
                    lastStep = nil
                    pulseOpacity = 0.18
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

        for _ in 0..<count {
            let x = CGFloat.random(in: 0...size.width)
            let y = CGFloat.random(in: 0...size.height)
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: max(8, mood.velocity - 10)...(mood.velocity + 10)) * 0.2
            let vx = cos(angle) * speed
            let vy = sin(angle) * speed
            let lifetime = Double.random(in: max(0.6, Double(mood.lifetime) - 0.3)...Double(mood.lifetime))
            let scale = CGFloat.random(in: 1.0...(2.0 + mood.scale))
            new.append(Particle(x: x, y: y, vx: vx, vy: vy, lifetime: lifetime, age: 0, scale: scale))
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
}
