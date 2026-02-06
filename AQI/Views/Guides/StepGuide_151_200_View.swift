//
//  StepGuide_151_200_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_151_200_View: View {
    var accentColor: Color = Color(red: 0.96, green: 0.34, blue: 0.28)

    private let title = "AQI 151–200 (Unhealthy)"
    private let subtitle = "Air quality is unhealthy. Sensitive groups should avoid long or intense outdoor activities and consider moving plans indoors. Everyone else should reduce long or intense activities and take more breaks outdoors."

    private let steps: [GuideStep] = [
        GuideStep(
            title: "Understand Your Air",
            content: "• Air pollution levels are high\n• Sensitive people are more likely to feel health effects\n• Others may still feel irritation during heavy outdoor activity"
        ),
        GuideStep(
            title: "What You Should Do",
            content: "Sensitive groups:\n• Avoid long or intense outdoor activities\n• Consider rescheduling or moving activities indoors\n\nEveryone else:\n• Reduce long or intense activities\n• Take more breaks during outdoor activities"
        ),
        GuideStep(
            title: "What to Avoid",
            content: "• Avoid strenuous workouts outdoors\n• Avoid long outdoor exertion, especially near traffic\n• Avoid pushing through symptoms like coughing or shortness of breath"
        ),
        GuideStep(
            title: "Who Needs Extra Care",
            content: "Sensitive groups include:\n• People with heart or lung disease\n• Older adults\n• Children and teenagers\n• Pregnant women\n• Outdoor workers"
        ),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Prefer indoor workouts and activities\n• Keep indoor air clean (avoid smoke)\n\nOutdoors\n• Keep trips short and light\n• Take breaks often and rest if irritation starts"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "• Coughing\n• Shortness of breath\n• Throat or eye irritation\n• Headache or unusual tiredness\n\nIf symptoms appear, slow down and move indoors."
        )
    ]

    var body: some View {
        StepGuideView(
            guideTitle: title,
            guideSubtitle: subtitle,
            steps: steps,
            accentColor: accentColor,
            aqiCategory: .unhealthy_151_200
        )
    }
}

#Preview {
    StepGuide_151_200_View()
}
