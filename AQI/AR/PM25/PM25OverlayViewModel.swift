import Foundation
import SwiftUI
import Combine

final class PM25OverlayViewModel: ObservableObject {
    // Do NOT write to this in didSet to avoid recursion.
    @Published var pm25: Double = 12

    // Adaptive quality: requested max particles target
    @Published var targetComplexity: Double = 1.5 // 0.5 = low, 1.0 = normal, 1.5 = high

    var displayValue: String { String(format: "%.0f", pm25) }

    var qualityLabel: String {
        switch pm25 {
        case ..<12: return "Clean"
        case 12..<35: return "Slightly Polluted"
        case 35..<55: return "Polluted"
        case 55..<150: return "Heavy"
        default: return "Extreme"
        }
    }
}
