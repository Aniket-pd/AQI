//
//  InfoActionCard.swift
//  AQI
//
//  Created by Codex on 15/1/26.
//

import SwiftUI

struct InfoActionCard: View {
    let iconName: String
    let accentColor: Color
    let title: String
    let badge: String?
    let subtitle: String
    let description: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(accentColor)
                .frame(width: 36, height: 36)
                .background(accentColor.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 8) {
                    Text(title)
                        .font(.headline)

                    if let badge = badge, !badge.isEmpty {
                        Text(badge)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                Text(subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(accentColor)

                Text(description)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer(minLength: 12)

            Button(buttonTitle) { action() }
                .buttonStyle(.borderedProminent)
                .tint(accentColor)
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
    InfoActionCard(
        iconName: "checkmark.seal.fill",
        accentColor: .green,
        title: "Good Air",
        badge: "AQI 0–50",
        subtitle: "Normal Day",
        description: "Air quality is safe for most people.",
        buttonTitle: "Start Guide",
        action: {}
    )
    .padding()
    .preferredColorScheme(.dark)
}

