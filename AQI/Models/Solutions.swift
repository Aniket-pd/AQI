//
//  Solutions.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

/// Six AQI bands the app already exposes via separate views.
enum AQICategory: CaseIterable {
    case good_0_50
    case moderate_51_100
    case usg_101_150        // Unhealthy for Sensitive Groups
    case unhealthy_151_200
    case veryUnhealthy_201_300
    case hazardous_300_plus
}

/// The three solution tiles we show in a row.
enum SolutionType: String, CaseIterable, Identifiable {
    case airPurifier
    case n95Mask
    case stayIndoor

    var id: String { rawValue }

    var title: String {
        switch self {
        case .airPurifier: return "Air Purifier"
        case .n95Mask:     return "N95 Mask"
        case .stayIndoor:  return "Stay Indoor"
        }
    }

    /// SF Symbols names chosen to be widely available and descriptive.
    var systemImageName: String {
        switch self {
        case .airPurifier: return "humidifier"       // resembles purifier device
        case .n95Mask:     return "facemask"         // iOS 15+
        case .stayIndoor:  return "house"
        }
    }
}

/// Visual severity level for color coding in UI.
enum SolutionSeverity {
    case safe
    case optional
    case recommended
    case required

    var color: Color {
        switch self {
        case .safe:
            return .green
        case .optional:
            return .yellow
        case .recommended:
            return .orange
        case .required:
            return .red
        }
    }
}

/// Central place to map an AQI band to the status strings shown on each tile.
enum SolutionsAdvisor {
    /// Returns a mapping for all three solutions for an AQI category.
    static func statuses(for category: AQICategory) -> [SolutionType: String] {
        switch category {
        case .good_0_50:
            return [
                .airPurifier: "Not needed",
                .n95Mask:     "Not needed",
                .stayIndoor:  "Safe"
            ]

        case .moderate_51_100:
            return [
                .airPurifier: "Optional",
                .n95Mask:     "Optional",
                .stayIndoor:  "Optional"
            ]

        case .usg_101_150:
            return [
                .airPurifier: "Use purifier",
                .n95Mask:     "Wear mask",
                .stayIndoor:  "Recommended"
            ]

        case .unhealthy_151_200:
            return [
                .airPurifier: "Use purifier",
                .n95Mask:     "Wear mask",
                .stayIndoor:  "Recommended"
            ]

        case .veryUnhealthy_201_300:
            return [
                .airPurifier: "Keep on",
                .n95Mask:     "Wear mask",
                .stayIndoor:  "Required"
            ]

        case .hazardous_300_plus:
            return [
                .airPurifier: "Keep on",
                .n95Mask:     "Required",
                .stayIndoor:  "Required"
            ]
        }
    }

    /// Returns severity level for each solution for color coding.
    static func severities(for category: AQICategory) -> [SolutionType: SolutionSeverity] {
        switch category {
        case .good_0_50:
            return [
                .airPurifier: .safe,
                .n95Mask: .safe,
                .stayIndoor: .safe
            ]

        case .moderate_51_100:
            return [
                .airPurifier: .optional,
                .n95Mask: .optional,
                .stayIndoor: .safe
            ]

        case .usg_101_150:
            return [
                .airPurifier: .recommended,
                .n95Mask: .recommended,
                .stayIndoor: .optional
            ]

        case .unhealthy_151_200:
            return [
                .airPurifier: .recommended,
                .n95Mask: .recommended,
                .stayIndoor: .recommended
            ]

        case .veryUnhealthy_201_300:
            return [
                .airPurifier: .required,
                .n95Mask: .required,
                .stayIndoor: .recommended
            ]

        case .hazardous_300_plus:
            return [
                .airPurifier: .required,
                .n95Mask: .required,
                .stayIndoor: .required
            ]
        }
    }
}
