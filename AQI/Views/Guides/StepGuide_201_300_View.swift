//
//  StepGuide_201_300_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_201_300_View: View {
    var accentColor: Color = Color(red: 0.72, green: 0.33, blue: 0.82)

    private let title = "AQI 201–300 (Very Unhealthy)"
    private let subtitle = "Health warnings of emergency conditions."
    private let steps: [GuideStep] = [
        GuideStep(title: "Avoid Exposure", content: "Stay indoors with doors/windows closed; postpone outdoor activities."),
        GuideStep(title: "High‑Filtration Mask", content: "Wear a well‑fitting N95/FFP2 if you must go outside."),
        GuideStep(title: "Support Vulnerable", content: "Check on children, elderly, and those with heart/lung disease.")
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

