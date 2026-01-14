//
//  StepGuide_301_Plus_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_301_Plus_View: View {
    var accentColor: Color = Color(red: 0.55, green: 0.12, blue: 0.16)

    private let title = "AQI 301+ (Hazardous)"
    private let subtitle = "Serious risk of health effects."
    private let steps: [GuideStep] = [
        GuideStep(title: "Remain Indoors", content: "Create a sealed clean room with a purifier running on high."),
        GuideStep(title: "Essential Only", content: "Avoid all non‑essential outdoor activity; use highest filtration mask if necessary."),
        GuideStep(title: "Seek Medical Advice", content: "If severe symptoms occur (breathing difficulty, chest pain), seek urgent help.")
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

