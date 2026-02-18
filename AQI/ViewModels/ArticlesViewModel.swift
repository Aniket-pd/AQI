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
            title: "Epilepsy Insights",
            subtitle: "Brain health & pollution",
            description: "Explore epilepsy, its symptoms, causes, and how clean air supports recovery.",
            sectionCount: "4 sections",
            bannerSymbol: "brain.head.profile",
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
