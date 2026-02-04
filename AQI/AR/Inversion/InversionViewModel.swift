import Foundation
import SwiftUI
import Combine

final class InversionViewModel: ObservableObject {
    // Time of day control (0 = sunrise, 0.5 = midday, 1 = sunset)
    @Published var timeOfDay: Double = 0.15
    // Legacy: atmospheric stability S: 0 = normal, 1 = severe inversion (derived from timeOfDay)
    // Use derivedStability for UI and controller updates.
    var derivedStability: Double {
        // U-shaped inversion strength: high at sunrise/sunset, low at midday
        // s(t) = (cos(2πt) + 1)/2, clamped to [0,1]
        // Optionally sharpen with a gentle exponent
        let t = max(0.0, min(1.0, timeOfDay))
        let base = (cos(2 * .pi * t) + 1.0) * 0.5
        let gamma = 1.15 // subtle sharpening; 1.0 for linear
        let s = pow(base, gamma)
        return max(0.0, min(1.0, s))
    }
    // Scale factor for particle complexity (0.5–1.5)
    @Published var targetComplexity: Double = 1.0

    enum PlacementState {
        case loadingModel
        case readyToPlace
        case placed
    }

    // Placement / loading state for UI overlays
    @Published var placementState: PlacementState = .loadingModel

    // UI helpers
    var stabilityLabel: String {
        let s = derivedStability
        switch s {
        case ..<0.2: return "Normal"
        case 0.2..<0.5: return "Weak"
        case 0.5..<0.8: return "Strong"
        default: return "Severe"
        }
    }
}
