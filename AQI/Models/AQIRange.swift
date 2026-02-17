//
//  AQIRange.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct AQIRange: Identifiable {
    let id = UUID()
    let category: AQICategory
    let title: String
    let summary: String
    let detail: String
    let iconName: String
    let accentColor: Color
    let buttonTitle: String

    var aqiRange: String {
        switch category {
        case .good_0_50: return "AQI 0-50"
        case .moderate_51_100: return "AQI 51-100"
        case .usg_101_150: return "AQI 101-150"
        case .unhealthy_151_200: return "AQI 151-200"
        case .veryUnhealthy_201_300: return "AQI 201-300"
        case .hazardous_300_plus: return "AQI 301+"
        }
    }
}
