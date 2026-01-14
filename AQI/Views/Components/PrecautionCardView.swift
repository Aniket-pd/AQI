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
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: range.iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(range.accentColor)
                .frame(width: 36, height: 36)
                .background(range.accentColor.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 8) {
                    Text(range.title)
                        .font(.headline)

                    Text(range.aqiRange)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(range.summary)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(range.accentColor)

                Text(range.detail)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer(minLength: 12)

            Button(range.buttonTitle) {}
                .buttonStyle(.borderedProminent)
                .tint(range.accentColor)
                .controlSize(.regular)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
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
