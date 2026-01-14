//
//  StepGuide_51_100_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_51_100_View: View {
    var accentColor: Color = Color(red: 0.96, green: 0.73, blue: 0.20)

    private let title = "AQI 51–100 (Moderate)"
    private let subtitle = "Acceptable; some concern for very sensitive people."
    private let steps: [GuideStep] = [
        GuideStep(title: "Moderation for Sensitive", content: "Sensitive individuals may reduce prolonged or heavy exertion outdoors."),
        GuideStep(title: "Close Monitoring", content: "If you have asthma/COPD, keep rescue meds handy."),
        GuideStep(title: "Plan Timing", content: "Prefer morning/evening when AQI trends lower, if applicable.")
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

