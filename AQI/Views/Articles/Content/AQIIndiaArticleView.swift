//
//  AQIIndiaArticleView.swift
//  AQI
//
//  Dedicated content for the AQI article with multiple sections.
//

import SwiftUI

struct AQIIndiaArticleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            ArticleSectionView(
                title: "When Pollution Becomes “Normal”",
                bodyText: "In places like Delhi, smoke, haze, and dust can become part of the background. When something is always around, the brain labels it as “normal life,” even if it’s harming us.\n\nThe scary part is that polluted air is a major health risk globally, not a rare event."
            )

            ArticleSectionView(
                title: "How Our Brain Learns to Ignore It",
                bodyText: "Our brains are built to react fast to sudden danger (like fire or loud sounds). Air pollution is different: it often harms quietly. If you don’t feel sharp pain today, the brain decides it’s not urgent.\n\nBut inside the body, breathing polluted air can still trigger harmful stress responses without you “feeling” them in a clear way."
            )

            ArticleSectionView(
                title: "The Illusion That Nothing Is Wrong",
                bodyText: "A common thought is: “If it was truly dangerous, I would feel it instantly.”\n\nThat’s not always true.\n\nMuch of the harm comes from long exposure to fine particles that can affect the lungs and cardiovascular system.\n\nSo “I feel okay today” doesn’t always mean “the air is harmless.”"
            )

            ArticleSectionView(
                title: "Breaking the Habit of Ignoring",
                bodyText: "You don’t need to become obsessed. You just need a small awareness loop:\n\n• Check air quality the same way you check the weather.\n• Notice patterns : headache days, cough days, breathless days.\n• On bad air days, reduce exposure by limiting time outdoors and heavy exercise.\n\nAwareness turns the invisible into something noticeable.\n\nAnd once something is noticeable, behavior changes become easier."
            )
        }
    }
}
