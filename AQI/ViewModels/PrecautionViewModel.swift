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
            title: "Good Air",
            aqiRange: "AQI 0–50",
            summary: "Normal Day",
            detail: "Air quality is safe for most people.",
            iconName: "checkmark.seal.fill",
            accentColor: Color(red: 0.23, green: 0.72, blue: 0.42),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Moderate Air",
            aqiRange: "AQI 51–100",
            summary: "Be Aware",
            detail: "Sensitive people may feel mild discomfort.",
            iconName: "exclamationmark.circle.fill",
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.2),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Poor Air",
            aqiRange: "AQI 101–200",
            summary: "Reduce Exposure",
            detail: "Air can affect health after prolonged exposure.",
            iconName: "person.fill",
            accentColor: Color(red: 0.95, green: 0.55, blue: 0.2),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Very Poor Air",
            aqiRange: "AQI 201–300",
            summary: "Protection Mode",
            detail: "Noticeable health effects; extra caution needed.",
            iconName: "exclamationmark.triangle.fill",
            accentColor: Color(red: 0.9, green: 0.35, blue: 0.35),
            buttonTitle: "Start Guide"
        ),
        AQIRange(
            title: "Severe Air",
            aqiRange: "AQI 300+",
            summary: "Stay Indoors",
            detail: "Air quality is dangerous; limit outdoor activity.",
            iconName: "wind",
            accentColor: Color(red: 0.79, green: 0.2, blue: 0.29),
            buttonTitle: "Start Guide"
        )
    ]
}
