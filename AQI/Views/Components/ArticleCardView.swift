//
//  ArticleCardView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article

    var body: some View {
        CardContainer(cornerRadius: 18, padding: 12) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    LinearGradient(
                        colors: article.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Image(systemName: article.bannerSymbol)
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(article.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(article.description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    Text(article.sectionCount)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
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
            gradientColors: [.red, .pink]
        )
    )
    .padding()
    .preferredColorScheme(.dark)
}
