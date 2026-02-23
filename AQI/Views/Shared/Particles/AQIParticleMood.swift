import SwiftUI
import UIKit

/// Describes particle configuration per AQI range/mood
struct AQIParticleMood {
    let color: UIColor
    let birthRate: Float
    let lifetime: Float
    let velocity: CGFloat
    let velocityRange: CGFloat
    let scale: CGFloat
    let scaleRange: CGFloat
    let alphaRange: Float
    let yAcceleration: CGFloat
    let xAcceleration: CGFloat
    let spinRange: CGFloat

    static func mood(for range: AQIRange) -> AQIParticleMood {
        let baseColor = UIColor(range.accentColor)

        switch range.category {
        case .good_0_50:
            return AQIParticleMood(
                color: baseColor.withAlphaComponent(0.9),
                birthRate: 25,
                lifetime: 1.2,
                velocity: 20,
                velocityRange: 18,
                scale: 0.8,
                scaleRange: 0.4,
                alphaRange: 0.25,
                yAcceleration: -4,
                xAcceleration: 2,
                spinRange: 0.3
            )
        case .moderate_51_100:
            return AQIParticleMood(
                color: baseColor.withAlphaComponent(0.95),
                birthRate: 45,
                lifetime: 1.3,
                velocity: 28,
                velocityRange: 22,
                scale: 0.95,
                scaleRange: 0.45,
                alphaRange: 0.3,
                yAcceleration: -6,
                xAcceleration: 4,
                spinRange: 0.4
            )
        case .usg_101_150:
            return AQIParticleMood(
                color: baseColor,
                birthRate: 75,
                lifetime: 1.35,
                velocity: 32,
                velocityRange: 26,
                scale: 1.0,
                scaleRange: 0.5,
                alphaRange: 0.35,
                yAcceleration: -8,
                xAcceleration: 6,
                spinRange: 0.5
            )
        case .unhealthy_151_200:
            return AQIParticleMood(
                color: baseColor,
                birthRate: 110,
                lifetime: 1.4,
                velocity: 36,
                velocityRange: 28,
                scale: 1.05,
                scaleRange: 0.55,
                alphaRange: 0.4,
                yAcceleration: -10,
                xAcceleration: 8,
                spinRange: 0.6
            )
        case .veryUnhealthy_201_300:
            return AQIParticleMood(
                color: baseColor,
                birthRate: 140,
                lifetime: 1.45,
                velocity: 40,
                velocityRange: 30,
                scale: 1.1,
                scaleRange: 0.6,
                alphaRange: 0.45,
                yAcceleration: -12,
                xAcceleration: 10,
                spinRange: 0.7
            )
        case .hazardous_300_plus:
            return AQIParticleMood(
                color: baseColor,
                birthRate: 180,
                lifetime: 1.5,
                velocity: 46,
                velocityRange: 34,
                scale: 1.15,
                scaleRange: 0.65,
                alphaRange: 0.5,
                yAcceleration: -14,
                xAcceleration: 12,
                spinRange: 0.8
            )
        }
    }
}

extension UIColor {
    convenience init(_ color: Color) {
        // Convert SwiftUI Color to UIColor safely
        if let cgColor = color.cgColor {
            self.init(cgColor: cgColor)
        } else {
            self.init(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
