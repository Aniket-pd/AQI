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
                    .foregroundColor(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(article.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))

                Text(article.description)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))

                Text(article.sectionCount)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .padding(12)
        .background(Color(red: 0.13, green: 0.13, blue: 0.17))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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
