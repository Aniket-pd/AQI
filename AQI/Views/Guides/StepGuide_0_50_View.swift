//
//  StepGuide_0_50_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_0_50_View: View {
    var accentColor: Color = Color(red: 0.23, green: 0.72, blue: 0.42)

    private let title = "AQI 0–50 (Good)"
    private let subtitle = "Air quality is good; enjoy normal activities."
    private let steps: [GuideStep] = [
        GuideStep(title: "Enjoy Outdoor Activities", content: "Air quality is good. Outdoor exercise and activities are encouraged."),
        GuideStep(title: "Routine Ventilation", content: "Open windows to refresh indoor air if outdoor air feels fresh."),
        GuideStep(title: "Stay Informed", content: "Check AQI periodically to plan your day confidently.")
    ]

    var body: some View {
        StepGuideView(
            guideTitle: title,
            guideSubtitle: subtitle,
            steps: steps,
            accentColor: accentColor
        )
    }
}

