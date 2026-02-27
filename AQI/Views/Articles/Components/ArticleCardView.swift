//
//  ArticleCardView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import UIKit

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Banner (image/illustration area)
            ZStack {
                if let image = UIImage(named: article.heroImageName) ?? UIImage(named: "Heat_inversion") {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                } else {
                    LinearGradient(
                        colors: article.heroGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }

                // Subtle dark fade at the bottom edge so the transition to the text area feels natural
                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .frame(height: 220)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 28,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 28
                )
            )

            // Text area (card footer)
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)

                if !article.subtitle.isEmpty {
                    Text(article.subtitle)
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                HStack(alignment: .center, spacing: 10) {
                    Text(article.sectionCount)
                        .font(.caption)
                        .foregroundStyle(.tertiary)

                    Spacer(minLength: 0)

                    if article.hasARExperience {
                        ArticleCardARBadge()
                            .accessibilityLabel("Includes AR view")
                    }
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        Color(.secondarySystemBackground),
                        Color(.secondarySystemBackground).opacity(0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 28,
                    bottomTrailingRadius: 28,
                    topTrailingRadius: 0
                )
            )
        }
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.25), radius: 18, x: 0, y: 10)
    }
}

#Preview {
    ArticleCardView(
        article: Article(
            title: "Understanding Cardiovascular Disease",
            subtitle: "Heart health & air quality",
            description: "Learn about cardiovascular diseases, their causes, symptoms, and prevention strategies.",
            sectionCount: "6 sections",
            bannerSymbol: "heart.fill",
            kind: .cardiovascular
        )
    )
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
