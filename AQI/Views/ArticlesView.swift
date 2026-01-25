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

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.articles) { article in
                        ArticleCardView(article: article)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Articles")
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    ArticlesView()
    .preferredColorScheme(.dark)
}
