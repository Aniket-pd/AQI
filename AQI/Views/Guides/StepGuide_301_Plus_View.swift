//
//  StepGuide_301_Plus_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_301_Plus_View: View {
    var accentColor: Color = Color(red: 0.55, green: 0.12, blue: 0.16)

    private let subtitle = "Air quality is hazardous. Everyone should avoid all physical activity outdoors. Sensitive groups should stay indoors, keep activity low, and take steps to reduce particle levels indoors."
    private let steps: [GuideStep] = [
        GuideStep(
            title: "Understand Your Air",
            content: "• Air pollution levels are extremely high\n• Health effects are likely for everyone\n• Sensitive groups are at highest risk"
        ),
        GuideStep(
            title: "What You Should Do",
            content: "Everyone:\n• Avoid all physical activity outdoors\n\nSensitive groups:\n• Remain indoors and keep activity levels low\n• Follow tips to keep particle levels low indoors"
        ),
        GuideStep(
            title: "What to Avoid",
            content: "• Avoid going outside unless it’s essential\n• Avoid outdoor exercise of any kind\n• Avoid physical exertion outdoors"
        ),
        GuideStep(
            title: "Who Needs Extra Care",
            content: "Sensitive groups include:\n• People with heart or lung disease\n• Older adults\n• Children and teenagers\n• Pregnant women\n• Outdoor workers"
        ),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Stay inside as much as possible\n• Keep windows and doors closed\n• Run an air purifier if available\n• Avoid indoor smoke (incense, cigarettes)\n\nHeat safety\n• If you don’t have AC and it’s extremely hot, staying sealed indoors can be unsafe\n• Go somewhere with air conditioning or check local cooling centers\n\nOutdoors\n• Go out only if necessary\n• Wear the best-fitting high-filtration mask you have"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "• Coughing\n• Shortness of breath\n• Chest tightness or pain\n• Dizziness\n• Severe fatigue\n\nIf severe symptoms occur, seek urgent medical help."
        )
    ]

    var body: some View {
        StepGuideView(
            guideSubtitle: subtitle,
            steps: steps,
            accentColor: accentColor,
            aqiCategory: .hazardous_300_plus
        )
    }
}

#Preview {
    StepGuide_301_Plus_View()
}
