//
//  PrecautionCardView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct PrecautionCardView: View {
    let range: AQIRange

    var body: some View {
        InfoActionCard(
            iconName: range.iconName,
            accentColor: range.accentColor,
            title: range.title,
            badge: range.aqiRange,
            subtitle: range.summary,
            description: range.detail,
            buttonTitle: range.buttonTitle,
            action: {}
        )
    }
}

#Preview {
    PrecautionCardView(
        range: AQIRange(
            title: "Good Air",
            aqiRange: "AQI 0–50",
            summary: "Normal Day",
            detail: "Air quality is safe for most people.",
            iconName: "checkmark.seal.fill",
            accentColor: .green,
            buttonTitle: "Start Guide"
        )
    )
    .padding()
    .preferredColorScheme(.dark)
}
