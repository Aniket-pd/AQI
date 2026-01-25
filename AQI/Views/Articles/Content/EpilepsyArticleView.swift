//
//  EpilepsyArticleView.swift
//  AQI
//
//  Dedicated content view for the epilepsy article.
//

import SwiftUI

struct EpilepsyArticleView: View {
    @State private var showAR = false
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ArticleSectionView(
                title: "What is epilepsy?",
                bodyText: "Epilepsy is a neurological condition characterized by a tendency to have recurrent seizures. Triggers vary and may include sleep deprivation, stress, illness, and occasionally environmental factors."
            )

            ArticleSectionView(
                title: "Air quality considerations",
                bodyText: "Poor air quality can contribute to respiratory irritation and sleep disruption, which may indirectly influence seizure thresholds for some people. Maintain good indoor air, especially during high AQI events."
            )

            ArticleSectionView(
                title: "Daily management tips",
                bodyText: "- Keep medications consistent and on schedule.\n- Prioritize adequate sleep and hydration.\n- Track symptoms and potential triggers.\n- Use AQI forecasts to plan activities."
            )

            ArticleARSection(
                title: "Explore Inversion Layers in AR",
                bodyText: "See how temperature inversions can trap pollutants near the ground. This AR experience places a simple inversion visualization in your space to reinforce the concept.",
                buttonTitle: "Start Inversion AR"
            ) {
                showAR = true
            }
        }
        .fullScreenCover(isPresented: $showAR) {
            InversionOverlayView()
        }
    }
}
