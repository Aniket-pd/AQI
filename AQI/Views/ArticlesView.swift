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
                        ArticleCardView(article: article)
                            .onTapGesture { selectedArticle = article }
                            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Articles")
            .background(Color(.systemGroupedBackground))
            .sheet(item: $selectedArticle) { article in
                ArticleDetailContainer(article: article)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(28)
            }
        }
    }
}

#Preview {
    ArticlesView()
    .preferredColorScheme(.dark)
}
