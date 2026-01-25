import SwiftUI

struct CardioArticleView: View {
    let article: Article
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    content
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Health Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { closeToolbar }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: article.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    Image(systemName: article.bannerSymbol)
                        .font(.system(size: 96, weight: .bold))
                        .foregroundStyle(.white.opacity(0.18))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding(24)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                Text(article.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(16)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.title3.bold())
            Text(article.description)
                .font(.body)
                .foregroundStyle(.primary)

            Text("Details")
                .font(.title3.bold())
                .padding(.top, 8)
            Text(article.body)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .padding(.horizontal, 16)
    }

    private var closeToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
            }
            .accessibilityLabel("Close")
        }
    }
}

