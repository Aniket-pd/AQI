//
//  ArticlesView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

struct ArticlesView: View {
    @StateObject private var viewModel = ArticlesViewModel()
    @State private var selectedArticle: Article?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.articles) { article in
                        Button {
                            selectedArticle = article
                        } label: {
                            ArticleCardView(article: article)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text("Open article: \(article.title)"))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Articles")
            .background(Color(.systemGroupedBackground))
            .sheet(item: $selectedArticle) { article in
                ArticleDetailSheetView(article: article) {
                    selectedArticle = nil
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled(false)
                .presentationCornerRadius(28)
            }
        }
    }
}

#Preview {
    ArticlesView()
    .preferredColorScheme(.dark)
}
