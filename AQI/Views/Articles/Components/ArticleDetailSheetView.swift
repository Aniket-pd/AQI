//
//  ArticleDetailSheetView.swift
//  AQI
//
//  Created by Codex on 26/1/26.
//

import SwiftUI

struct ArticleDetailSheetView: View {
    let article: Article
    var onClose: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image (edge-to-edge inside the sheet)
                    Image("Heat_inversion")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 220, maxHeight: 260)
                        .clipped()

                    // Headline and content
                    VStack(alignment: .leading, spacing: 16) {
                        Text(article.title)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.leading)
                            .accessibilityAddTraits(.isHeader)

                        if !article.description.isEmpty {
                            Text(article.description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }

                        VStack(alignment: .leading, spacing: 24) {
                            switch article.kind {
                            case .cardiovascular:
                                CardiovascularArticleView()
                            case .epilepsy:
                                EpilepsyArticleView()
                            case .aqiIndia:
                                AQIIndiaArticleView()
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle(headerTitle(for: article.kind))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { onClose?() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                    }
                    .accessibilityLabel(Text("Close"))
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .environment(\.colorScheme, .dark)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
    }

    private func headerTitle(for kind: ArticleKind) -> String {
        switch kind {
        case .cardiovascular: return "Cardio Fitness Article"
        case .epilepsy: return "Neurology Article"
        case .aqiIndia: return "AQI Article"
        }
    }
}

// MARK: - Reusable Section Helpers

struct ArticleSectionView: View {
    let title: String
    let bodyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
            Text(bodyText)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

struct ArticleARSection: View {
    let title: String
    let bodyText: String
    let buttonTitle: String
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)

            Text(bodyText)
                .font(.body)
                .foregroundColor(.primary)

            Button(buttonTitle, action: action)
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .font(.body.weight(.semibold))
                .accessibilityHint("Opens an AR experience")
        }
    }
}

#Preview {
    ArticleDetailSheetView(
        article: Article(
            title: "Learn About Cardio Fitness",
            subtitle: "Understanding VO₂ max and heart health",
            description: "Cardio fitness, or cardiorespiratory fitness, is your body’s ability to take in, circulate and use oxygen.",
            sectionCount: "5",
            bannerSymbol: "heart.fill",
            gradientColors: [.pink, .red],
            kind: .cardiovascular
        ),
        onClose: {}
    )
}
