//
//  StepGuide_101_150_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_101_150_View: View {
    var accentColor: Color = Color(red: 0.95, green: 0.55, blue: 0.20)

    private let title = "AQI 101–150 (USG)"
    private let subtitle = "Unhealthy for sensitive groups (USG)."
    private let steps: [GuideStep] = [
        GuideStep(title: "Limit Exposure", content: "Sensitive groups should limit time outdoors and avoid heavy exertion."),
        GuideStep(title: "Use Masks if Needed", content: "Consider a certified mask during commutes or outdoor tasks."),
        GuideStep(title: "Ventilation Care", content: "Keep windows closed if outdoor air smells smokey or hazy.")
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

