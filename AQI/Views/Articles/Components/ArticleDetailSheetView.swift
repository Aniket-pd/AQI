//
//  ArticleDetailSheetView.swift
//  AQI
//
//  Created by Codex on 26/1/26.
//

import SwiftUI
import UIKit

struct ArticleDetailSheetView: View {
    let article: Article
    var onClose: (() -> Void)? = nil

    private var sheetBackgroundColor: Color {
        Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
                ? UIColor.secondarySystemBackground
                : UIColor.systemBackground
        })
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero image (edge-to-edge inside the sheet)
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
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.6, contentMode: .fill)
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
            .background(sheetBackgroundColor)
        }
        .background(sheetBackgroundColor)
    }

    private func headerTitle(for kind: ArticleKind) -> String {
        switch kind {
        case .cardiovascular: return "Cardio Fitness Article"
        case .epilepsy: return "Temperature Inversions"
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
                .font(.title2.weight(.semibold))
                .foregroundColor(.primary)
            ArticleBodyText(bodyText: bodyText)
        }
    }
}

struct ReferenceLink: Identifiable {
    let id = UUID()
    let title: String
    let url: URL

    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }

    init?(title: String, urlString: String) {
        guard let url = URL(string: urlString) else { return nil }
        self.init(title: title, url: url)
    }
}

struct ReferenceLinksSection: View {
    let title: String
    let buttonTitle: String
    let references: [ReferenceLink]

    @State private var isShowingSheet = false

    var body: some View {
        if !references.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)

                Button(buttonTitle) {
                    isShowingSheet = true
                }
                .buttonStyle(.bordered)
                .font(.body.weight(.semibold))
                .accessibilityLabel("\(buttonTitle)")
            }
            .sheet(isPresented: $isShowingSheet) {
                ReferenceLinksSheet(title: title, references: references)
            }
        }
    }
}

struct ReferenceLinksSheet: View {
    let title: String
    let references: [ReferenceLink]

    @State private var contentHeight: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(references) { reference in
                        Link(destination: reference.url) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(reference.title)
                                    .font(.footnote.weight(.semibold))
                                    .foregroundColor(.primary)

                                Text(reference.url.absoluteString)
                                    .font(.caption.monospaced())
                                    .foregroundColor(.secondary)
                                    .textSelection(.enabled)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
            }
            .padding(20)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ReferenceSheetHeightKey.self, value: proxy.size.height)
                }
            )
        }
        .onPreferenceChange(ReferenceSheetHeightKey.self) { newHeight in
            contentHeight = newHeight
        }
        .presentationDetents(sheetDetents)
    }

    private var sheetDetents: Set<PresentationDetent> {
        guard contentHeight > 0 else { return [.medium, .large] }
        let maxHeight = UIScreen.main.bounds.height * 0.9
        if contentHeight < maxHeight {
            return [.height(contentHeight)]
        }
        return [.large]
    }
}

private struct ReferenceSheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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

            ArticleBodyText(bodyText: bodyText)

            HStack {
                Spacer()
                Button(action: action) {
                    Label(buttonTitle, systemImage: "arkit")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .font(.body.weight(.semibold))
                .controlSize(.large)
                .frame(minWidth: 160)
                .accessibilityHint("Opens an AR experience")
                Spacer()
            }
            .padding(.top, 4)
        }
    }
}

private struct ArticleBodyText: View {
    let bodyText: String
    let paragraphSpacing: CGFloat = 8

    var body: some View {
        VStack(alignment: .leading, spacing: paragraphSpacing) {
            ForEach(paragraphs.indices, id: \.self) { index in
                Text(paragraphs[index])
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
    }

    private var paragraphs: [String] {
        bodyText
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
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
            kind: .cardiovascular
        ),
        onClose: {}
    )
}
