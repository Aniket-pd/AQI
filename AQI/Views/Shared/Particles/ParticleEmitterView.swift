import SwiftUI
import UIKit

/// A lightweight CAEmitterLayer wrapper that emits a brief, subtle burst
/// of particles across the full bounds of the view, clipped by bounds.
struct ParticleEmitterView: UIViewRepresentable {
    var mood: AQIParticleMood
    var cornerRadius: CGFloat
    var trigger: UUID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeUIView(context: Context) -> EmitterHostView {
        let view = EmitterHostView()
        view.isUserInteractionEnabled = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        context.coordinator.configure(on: view, mood: mood)
        // Prevent auto-fire on first render
        context.coordinator.lastTrigger = trigger
        return view
    }

    func updateUIView(_ uiView: EmitterHostView, context: Context) {
        // Update corner radius in case layout changes
        uiView.layer.cornerRadius = cornerRadius
        context.coordinator.updateMood(mood, on: uiView)
        // When trigger changes, play a short burst (unless reduce motion)
        if context.coordinator.lastTrigger != trigger {
            context.coordinator.lastTrigger = trigger
            if reduceMotion {
                // Minimal alternative: a soft luminance pulse
                context.coordinator.pulse(on: uiView)
            } else {
                context.coordinator.playBurst(on: uiView)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    // MARK: - Host view
    class EmitterHostView: UIView {
        let emitter = CAEmitterLayer()
        override init(frame: CGRect) {
            super.init(frame: frame)
            layer.addSublayer(emitter)
        }
        required init?(coder: NSCoder) { super.init(coder: coder); layer.addSublayer(emitter) }
        override func layoutSubviews() {
            super.layoutSubviews()
            emitter.frame = bounds
            emitter.emitterShape = .rectangle
            emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
            emitter.emitterSize = bounds.size
        }
    }

    // MARK: - Coordinator
    class Coordinator {
        var lastTrigger = UUID()
        private var mood: AQIParticleMood?

        func configure(on host: EmitterHostView, mood: AQIParticleMood) {
            self.mood = mood
            host.emitter.masksToBounds = true
            host.emitter.renderMode = .unordered
            // Keep layer birthRate at 1; we gate emission via the cell's birthRate during bursts.
            host.emitter.birthRate = 1
            host.emitter.emitterMode = .volume
            host.emitter.emitterCells = [makeCell(for: mood)]
        }

        func updateMood(_ mood: AQIParticleMood, on host: EmitterHostView) {
            // If mood changed, rebuild cells
            if self.mood?.birthRate != mood.birthRate || self.mood?.velocity != mood.velocity {
                self.mood = mood
                host.emitter.emitterCells = [makeCell(for: mood)]
            }
        }

        func makeCell(for mood: AQIParticleMood) -> CAEmitterCell {
            let cell = CAEmitterCell()
            cell.contents = dotImage().cgImage
            cell.birthRate = 0 // controlled during burst
            cell.lifetime = mood.lifetime
            cell.lifetimeRange = 0.2
            cell.velocity = mood.velocity
            cell.velocityRange = mood.velocityRange
            cell.xAcceleration = mood.xAcceleration
            cell.yAcceleration = mood.yAcceleration
            cell.emissionRange = .pi * 2
            // Slightly larger for visibility while staying subtle
            cell.scale = 0.035 * mood.scale
            cell.scaleRange = 0.02 * max(0.5, mood.scaleRange)
            cell.alphaRange = mood.alphaRange
            cell.alphaSpeed = -0.45
            cell.spinRange = mood.spinRange
            cell.color = mood.color.cgColor
            cell.name = "aqi_particle"
            return cell
        }

        func playBurst(on host: EmitterHostView) {
            let burstDuration: CFTimeInterval = 0.9

            // Temporarily increase birth rate for a short time
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            host.emitter.beginTime = CACurrentMediaTime()
            host.emitter.setValue(mood?.birthRate ?? 60, forKeyPath: "emitterCells.aqi_particle.birthRate")
            CATransaction.commit()

            DispatchQueue.main.asyncAfter(deadline: .now() + burstDuration) {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                host.emitter.setValue(0, forKeyPath: "emitterCells.aqi_particle.birthRate")
                CATransaction.commit()
            }
        }

        func pulse(on host: EmitterHostView) {
            // Subtle white overlay pulse to respect Reduce Motion
            let overlay = CALayer()
            overlay.frame = host.bounds
            overlay.cornerRadius = host.layer.cornerRadius
            overlay.masksToBounds = true
            overlay.backgroundColor = UIColor(white: 1.0, alpha: 1.0).cgColor
            overlay.opacity = 0
            host.layer.addSublayer(overlay)

            let anim = CABasicAnimation(keyPath: "opacity")
            anim.fromValue = 0.0
            anim.toValue = 0.16
            anim.autoreverses = true
            anim.duration = 0.45
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                overlay.removeFromSuperlayer()
            }
            overlay.add(anim, forKey: "reduceMotionPulse")
            CATransaction.commit()
        }

        private func dotImage() -> UIImage {
            let size: CGFloat = 10
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size), format: format)
            return renderer.image { ctx in
                let rect = CGRect(x: 0, y: 0, width: size, height: size)
                UIColor.white.setFill()
                UIBezierPath(ovalIn: rect).fill()
            }
        }
    }
}
