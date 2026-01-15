import Foundation
import SwiftUI
import Combine

final class PM25OverlayViewModel: ObservableObject {
    @Published var pm25: Double = 12 { didSet { pm25 = max(0, pm25) } }
    @Published var isLive: Bool = false
    @Published var breathActive: Bool = false

    // Adaptive quality: requested max particles target
    @Published var targetComplexity: Double = 1.0 // 0.5 = low, 1.0 = normal, 1.5 = high

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

