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
            title: "Good",
            aqiRange: "AQI 0–50",
            summary: "Normal Day",
            detail: "Air quality poses little or no risk.",
            iconName: "checkmark.seal.fill",
            accentColor: Color(red: 0.23, green: 0.72, blue: 0.42),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Moderate",
            aqiRange: "AQI 51–100",
            summary: "Be Aware",
            detail: "Acceptable; some concern for very sensitive people.",
            iconName: "exclamationmark.circle.fill",
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.20),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "USG",
            aqiRange: "AQI 101–150",
            summary: "Sensitive Groups",
            detail: "Unhealthy for sensitive groups (USG).",
            iconName: "heart.text.square.fill",
            accentColor: Color(red: 0.95, green: 0.55, blue: 0.20),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Unhealthy",
            aqiRange: "AQI 151–200",
            summary: "Reduce Exposure",
            detail: "Everyone may begin to experience health effects.",
            iconName: "lungs.fill",
            accentColor: Color(red: 0.96, green: 0.34, blue: 0.28),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Very Unhealthy",
            aqiRange: "AQI 201–300",
            summary: "Protection Mode",
            detail: "Health warnings of emergency conditions.",
            iconName: "exclamationmark.triangle.fill",
            accentColor: Color(red: 0.72, green: 0.33, blue: 0.82),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Hazardous",
            aqiRange: "AQI 301+",
            summary: "Stay Indoors",
            detail: "Serious risk of health effects.",
            iconName: "aqi.low",
            accentColor: Color(red: 0.55, green: 0.12, blue: 0.16),
            buttonTitle: "Start Guide"
        )
    ]
}
