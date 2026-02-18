//
//  ArticlesViewModel.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

final class ArticlesViewModel: ObservableObject {
    let articles: [Article] = [
        Article(
            title: "Know Your Enemy: PM2.5",
            subtitle: "PM2.5 basics & AR",
            description: "Understand what PM2.5 is, why it matters, and how to visualize it with AR.",
            sectionCount: "6 sections",
            bannerSymbol: "heart.fill",
            kind: .cardiovascular
        ),
        Article(
            title: "When the Air Stops Moving",
            subtitle: "Understanding Temperature Inversions",
            description: "Learn how inversions form, why pollution gets trapped near the ground, and how to time outdoor activity more safely.",
            sectionCount: "7 sections",
            bannerSymbol: "wind",
            kind: .epilepsy
        ),
        Article(
            title: "Why AQI Matters in India",
            subtitle: "Daily exposure explained",
            description: "Understand how AQI is measured and when to reduce outdoor activity.",
            sectionCount: "5 sections",
            bannerSymbol: "sun.haze.fill",
            kind: .aqiIndia
        )
    ]
}
