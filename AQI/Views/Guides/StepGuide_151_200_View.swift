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
    private let subtitle = "Everyone may begin to experience health effects."
    private let steps: [GuideStep] = [
        GuideStep(title: "Reduce Outdoor Time", content: "Everyone should reduce prolonged or heavy outdoor exertion."),
        GuideStep(title: "Indoor Air Quality", content: "Use air purifiers; create a clean room if possible."),
        GuideStep(title: "Health Watch", content: "If coughing, wheezing, or headache occurs, further reduce exposure and rest.")
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

