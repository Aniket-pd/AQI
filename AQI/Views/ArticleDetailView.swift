//
//  ArticleDetailView.swift
//  AQI
//
//  Created by Assistant on 25/1/26.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero header
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: article.gradientColors.isEmpty ? [Color.blue, Color.purple] : article.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 240)
                    .overlay(
                        Image(systemName: article.bannerSymbol)
                            .font(.system(size: 96, weight: .bold))
                            .foregroundStyle(.white.opacity(0.18))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .padding(24)
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.title)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        Text(article.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    .padding(16)
                }
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Body content
                VStack(alignment: .leading, spacing: 16) {
                    if !article.description.isEmpty {
                        Text(article.description)
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }

                    Text(article.body)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Article Detail", kind: .detail) {
    NavigationStack {
        ArticleDetailView(
            article: Article(
                title: "Why AQI Matters in India",
                subtitle: "Daily exposure explained",
                description: "Understand how AQI is measured and when to reduce outdoor activity.",
                body: "Sample body text for preview.\n\nMultiple paragraphs supported.",
                sectionCount: "5 sections",
                bannerSymbol: "sun.haze.fill",
                gradientColors: [.orange, .pink]
            )
        )
    }
    .preferredColorScheme(.dark)
}
