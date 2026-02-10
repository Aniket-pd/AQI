//
//  SignalModels.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

enum BodySignalKind: Hashable {
    case breathingDiscomfort
    case eyeThroatIrritation
    case unusualFatigue
    case headacheHeavyHead
    case poorFocusBrainFog
    case lowEnergy
    case noseIrritation
    case poorSleep
}

struct SignalSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [SignalItem]
}

struct SignalItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let tintColor: Color
    let kind: BodySignalKind
}

// Centralized icon and accent color mapping for each signal kind
extension BodySignalKind {
    var iconName: String {
        switch self {
        case .breathingDiscomfort:
            return "lungs.fill"
        case .eyeThroatIrritation:
            return "eye.fill"
        case .unusualFatigue:
            return "bolt.slash.fill"
        case .headacheHeavyHead:
            return "waveform.path.ecg"
        case .poorFocusBrainFog:
            return "brain"
        case .lowEnergy:
            return "battery.25"
        case .noseIrritation:
            return "aqi.low"
        case .poorSleep:
            return "bed.double.fill"
        }
    }

    // Must match the accent/gradient color used in SignalDetailView
    var accentColor: Color {
        switch self {
        case .breathingDiscomfort:
            return Color(red: 0.86, green: 0.62, blue: 0.62)
        case .eyeThroatIrritation:
            return Color(red: 0.84, green: 0.66, blue: 0.34)
        case .unusualFatigue:
            return Color(red: 0.68, green: 0.62, blue: 0.86)
        case .headacheHeavyHead:
            return Color(red: 0.58, green: 0.72, blue: 0.86)
        case .poorFocusBrainFog:
            return Color(red: 0.38, green: 0.83, blue: 0.59)
        case .lowEnergy:
            return Color(red: 0.96, green: 0.73, blue: 0.20)
        case .noseIrritation:
            return Color(red: 0.72, green: 0.64, blue: 0.78)
        case .poorSleep:
            return Color(red: 0.56, green: 0.60, blue: 0.80)
        }
    }
}
