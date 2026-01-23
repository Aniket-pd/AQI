//
//  PrecautionCardView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct PrecautionCardView: View {
    let range: AQIRange
    var onStartGuide: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 14) {

            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: range.iconName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(range.accentColor)
                        .frame(width: 28, height: 28)
                        .background(range.accentColor.opacity(0.15))
                        .clipShape(Circle())

                    Text(range.title)
                        .font(.headline)

                    Text(range.aqiRange)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(range.summary)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(range.accentColor)

                    Text(range.detail)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.leading, 36)
            }

            Spacer(minLength: 12)

            Button(range.buttonTitle) {
                onStartGuide?()
            }
                .buttonStyle(.borderedProminent)
                .tint(range.accentColor)
                .controlSize(.regular)
        }
        .padding(16)
        .cardBackground(cornerRadius: 20)
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
            buttonTitle: "Guide"
        )
    )
    .padding()
    .preferredColorScheme(.dark)
}
