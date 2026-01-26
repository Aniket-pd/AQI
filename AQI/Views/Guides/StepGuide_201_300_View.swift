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
    private let subtitle = "Air quality is very unhealthy. Sensitive groups should avoid all outdoor physical activity. Everyone else should avoid long or intense activities and consider moving plans indoors."

    private let steps: [GuideStep] = [
        GuideStep(
            title: "Understand Your Air",
            content: "• Air pollution levels are very high\n• Health effects are likely for everyone\n• Sensitive groups are at higher risk"
        ),
        GuideStep(
            title: "What You Should Do",
            content: "Sensitive groups:\n• Avoid all physical activity outdoors\n• Reschedule activities to a time with better air\n• Move activities indoors\n\nEveryone else:\n• Avoid long or intense activities\n• Consider rescheduling or moving activities indoors"
        ),
        GuideStep(
            title: "What to Avoid",
            content: "• Avoid all outdoor exercise\n• Avoid long outdoor exposure\n• Avoid physical exertion outside"
        ),
        GuideStep(
            title: "Who Needs Extra Care",
            content: "Sensitive groups include:\n• People with heart or lung disease\n• Older adults\n• Children and teenagers\n• Pregnant women\n• Outdoor workers"
        ),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Stay indoors as much as possible\n• Keep windows and doors closed\n• Use air purifiers if available\n\nOutdoors\n• Go outside only if necessary\n• Wear a mask if you must go out"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "• Coughing\n• Shortness of breath\n• Chest tightness\n• Headache or dizziness\n• Extreme tiredness\n\nIf symptoms appear, seek medical advice."
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
    StepGuide_201_300_View()
}
