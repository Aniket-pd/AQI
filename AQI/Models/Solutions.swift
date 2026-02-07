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
        case .n95Mask:     return "N95 Safety Mask"
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

/// Central place to map an AQI band to the status strings shown on each tile.
enum SolutionsAdvisor {
    /// Returns a mapping for all three solutions for an AQI category.
    static func statuses(for category: AQICategory) -> [SolutionType: String] {
        switch category {
        case .good_0_50:
            return [
                .airPurifier: "Optional",
                .n95Mask:     "Not Needed",
                .stayIndoor:  "Enjoy Outside"
            ]

        case .moderate_51_100:
            return [
                .airPurifier: "Optional",
                .n95Mask:     "Optional",
                .stayIndoor:  "Normal"
            ]

        case .usg_101_150:
            return [
                .airPurifier: "Turn On",
                .n95Mask:     "Consider",
                .stayIndoor:  "Reduce Outdoor"
            ]

        case .unhealthy_151_200:
            return [
                .airPurifier: "Turn On",
                .n95Mask:     "Recommended",
                .stayIndoor:  "Recommended"
            ]

        case .veryUnhealthy_201_300:
            return [
                .airPurifier: "Turn On",
                .n95Mask:     "Recommended",
                .stayIndoor:  "Limit Outdoor"
            ]

        case .hazardous_300_plus:
            return [
                .airPurifier: "Turn On",
                .n95Mask:     "Must",
                .stayIndoor:  "Stay Indoor"
            ]
        }
    }
}

