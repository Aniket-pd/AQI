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
            title: "Understanding Cardiovascular Disease",
            subtitle: "Heart health & air quality",
            description: "Learn about cardiovascular diseases, their causes, symptoms, and prevention strategies.",
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
