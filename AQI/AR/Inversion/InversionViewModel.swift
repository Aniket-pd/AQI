import Foundation
import SwiftUI
import Combine

final class InversionViewModel: ObservableObject {
    // Time of day control (0 = early morning, 1 = afternoon)
    @Published var timeOfDay: Double = 0.15
    // Legacy: atmospheric stability S: 0 = normal, 1 = severe inversion (derived from timeOfDay)
    // Use derivedStability for UI and controller updates.
    var derivedStability: Double {
        // Map time to inversion strength: strong in early morning, weak by afternoon
        // s = 1 at t=0, ~0.1 at t=1 with a gentle S-curve
        let t = max(0.0, min(1.0, timeOfDay))
        // Emphasize morning stability; accelerate weakening past mid-morning
        let weaken = 0.5 * (1 - cos(.pi * min(1.0, max(0.0, (t - 0.1) / 0.9)))) // smooth 0..1
        let s = 1.0 - 0.9 * weaken
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
