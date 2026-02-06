//
//  StepGuide_101_150_View.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuide_101_150_View: View {
    var accentColor: Color = Color(red: 0.95, green: 0.55, blue: 0.20)

    private let title = "AQI 101–150 (Unhealthy for Sensitive Groups)"
    private let subtitle = "Air quality may begin to affect sensitive individuals. Most people can continue normal activities, but people in sensitive groups should reduce outdoor exertion and watch for symptoms."
    private let steps: [GuideStep] = [
        GuideStep(
            title: "Understand Your Air",
            content: "• Air pollution levels are moderately high\n• Most healthy people may feel okay\n• Sensitive groups may start to notice effects"
        ),
        GuideStep(
            title: "What You Should Do",
            content: "Sensitive groups:\n• Make outdoor activities shorter and less intense\n• Take more breaks while outdoors\n• Watch for coughing or shortness of breath\n\nPeople with asthma:\n• Follow your asthma action plan\n• Keep quick-relief medicine handy\n\nPeople with heart disease:\n• Watch for palpitations, shortness of breath, or unusual fatigue\n• Contact your health care provider if these occur"
        ),
        GuideStep(
            title: "What to Avoid",
            content: "• Avoid long or intense outdoor activities if you’re sensitive\n• Avoid heavy physical work outdoors\n• Avoid pushing through symptoms"
        ),
        GuideStep(
            title: "Who Needs Extra Care",
            content: "Sensitive groups include:\n• People with heart or lung disease\n• Older adults\n• Children and teenagers\n• Pregnant women\n• Outdoor workers"
        ),
        GuideStep(
            title: "Indoor vs Outdoor Tips",
            content: "Indoors\n• Take breaks indoors when needed\n• Keep indoor air clean\n\nOutdoors\n• It’s OK to be active outdoors\n• Keep activities lighter and shorter\n• Rest more often during exertion"
        ),
        GuideStep(
            title: "Body Signals to Watch",
            content: "• Coughing\n• Shortness of breath\n• Chest discomfort\n• Unusual tiredness\n\nIf symptoms appear, slow down and reduce outdoor activity."
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
    StepGuide_101_150_View()
}

