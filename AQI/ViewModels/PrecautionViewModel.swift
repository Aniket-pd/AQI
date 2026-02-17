//
//  PrecautionViewModel.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

final class PrecautionViewModel: ObservableObject {
    let ranges: [AQIRange] = [
        AQIRange(
            category: .good_0_50,
            title: "Good",
            summary: "Normal Day",
            detail: "Air quality poses little or no risk.",
            iconName: "checkmark.seal.fill",
            accentColor: Color(red: 0.23, green: 0.72, blue: 0.42),
            buttonTitle: "Guide"
        ),
        AQIRange(
            category: .moderate_51_100,
            title: "Moderate",
            summary: "Be Aware",
            detail: "Acceptable; some concern for very sensitive people.",
            iconName: "exclamationmark.circle.fill",
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.20),
            buttonTitle: "Guide"
        ),
        AQIRange(
            category: .usg_101_150,
            title: "USG",
            summary: "Sensitive Groups",
            detail: "Unhealthy for sensitive groups (USG).",
            iconName: "heart.text.square.fill",
            accentColor: Color(red: 0.95, green: 0.55, blue: 0.20),
            buttonTitle: "Guide"
        ),
        AQIRange(
            category: .unhealthy_151_200,
            title: "Unhealthy",
            summary: "Reduce Exposure",
            detail: "Everyone may begin to experience health effects.",
            iconName: "lungs.fill",
            accentColor: Color(red: 0.96, green: 0.34, blue: 0.28),
            buttonTitle: "Guide"
        ),
        AQIRange(
            category: .veryUnhealthy_201_300,
            title: "Very Unhealthy",
            summary: "Protection Mode",
            detail: "Health warnings of emergency conditions.",
            iconName: "exclamationmark.triangle.fill",
            accentColor: Color(red: 0.72, green: 0.33, blue: 0.82),
            buttonTitle: "Guide"
        ),
        AQIRange(
            category: .hazardous_300_plus,
            title: "Hazardous",
            summary: "Stay Indoors",
            detail: "Serious risk of health effects.",
            iconName: "aqi.low",
            accentColor: Color(red: 0.55, green: 0.12, blue: 0.16),
            buttonTitle: "Guide"
        )
    ]
}
