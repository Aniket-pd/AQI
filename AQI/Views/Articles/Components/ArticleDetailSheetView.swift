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
        VStack(spacing: 0) {
            // Header: centered title with close button on the right
            ZStack {
                Text(headerTitle(for: article.kind))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)

                HStack {
                    Spacer()
                    Button(action: { onClose?() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(.thinMaterial, in: Circle())
                    }
                    .accessibilityLabel(Text("Close"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 8)

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
                                .foregroundStyle(.secondary)
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
        }
        .background(Color(.systemBackground))
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
                .foregroundStyle(.primary)
            Text(bodyText)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
