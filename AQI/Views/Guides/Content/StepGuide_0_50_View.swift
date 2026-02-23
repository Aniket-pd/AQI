//
//  StepGuide_0_50_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_0_50_View: View {
    var accentColor: Color = Color(red: 0.23, green: 0.72, blue: 0.42)
    private let subtitle = "The air is clean and healthy to breathe. It’s a great time to go outside, stay active, and enjoy your day as usual."
    private let steps: [GuideStep] = [
        GuideStep(title: "Air Overview", content: "• Air quality is good.\n• The air is safe for everyday activities."),
        GuideStep(title: "What You Should Do", content: "• Enjoy outdoor activities normally\n• Go for walks, runs, or exercise outside\n• Open windows to let fresh air in\n• Spend time outdoors if you can"),
        GuideStep(title: "What to Avoid", content: "• No special restrictions needed\n• Just avoid adding unnecessary pollution"),
        GuideStep(title: "Who Needs Extra Care", content: "• Air quality is safe for everyone"),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Keep windows open\n• Let fresh air circulate\n\nOutdoors\n• Safe for all activities\n• Ideal for exercise and play"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "• No pollution-related symptoms expected"
        ),
    ]

    var body: some View {
        StepGuideView(
            guideSubtitle: subtitle,
            steps: steps,
            accentColor: accentColor,
            aqiCategory: .good_0_50
        )
    }
}

#Preview {
    StepGuide_0_50_View()
}
