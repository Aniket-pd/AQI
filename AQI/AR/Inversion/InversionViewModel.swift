import Foundation
import SwiftUI
import Combine

final class InversionViewModel: ObservableObject {
    // Atmospheric stability S: 0 = normal, 1 = severe inversion
    @Published var stability: Double = 0.0
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
        let s = stability
        switch s {
        case ..<0.2: return "Normal"
        case 0.2..<0.5: return "Weak"
        case 0.5..<0.8: return "Strong"
        default: return "Severe"
        }
    }
}
