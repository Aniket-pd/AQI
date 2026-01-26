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
    private let subtitle = "The air quality is generally acceptable. However, some people who are unusually sensitive to air pollution may experience mild effects. For most people, the air is safe and does not cause problems."

    private let steps: [GuideStep] = [
        GuideStep(
            title: "Understand Your Air",
            content: "• Air quality is okay for daily life\n• You can go about your normal routine without concern\n\nSensitive individuals may notice:\n• Slight discomfort\n• Mild breathing irritation\n\nSerious health effects are unlikely"
        ),
        GuideStep(
            title: "What You Should Do",
            content: "For most people:\n• Continue outdoor activities as usual\n• Walk, commute, and exercise normally\n• Open windows if the air feels comfortable\n\nIf you are sensitive:\n• Choose lighter exercise\n• Take short breaks if you feel discomfort"
        ),
        GuideStep(
            title: "What to Avoid",
            content: "• No major restrictions are needed\n\nSensitive people may consider:\n• Avoiding very intense outdoor workouts\n• Avoiding long exposure near heavy traffic"
        ),
        GuideStep(
            title: "Who Needs Extra Care",
            content: "• People with asthma or lung problems\n• People who get irritated easily by pollution\n\nEveryone else can live normally"
        ),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Windows can stay open\n• Normal ventilation is fine\n\nOutdoors\n• Safe for most activities\n• Reduce effort if irritation appears"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "Sensitive people may notice:\n• Mild eye irritation\n• Slight throat dryness\n• Light coughing\n• Feeling a bit tired\n\nThese are signs to slow down"
        )
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

#Preview {
    StepGuide_51_100_View()
}
