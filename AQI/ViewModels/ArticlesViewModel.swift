//
//  ArticlesViewModel.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

final class ArticlesViewModel: ObservableObject {
    let articles: [Article] = [
        Article(
            title: "Understanding Cardiovascular Disease",
            subtitle: "Heart health & air quality",
            description: "Learn about cardiovascular diseases, their causes, symptoms, and prevention strategies.",
            sectionCount: "6 sections",
            bannerSymbol: "heart.fill",
            gradientColors: [Color(red: 0.65, green: 0.06, blue: 0.18), Color(red: 0.9, green: 0.27, blue: 0.35)]
        ),
        Article(
            title: "Epilepsy Insights",
            subtitle: "Brain health & pollution",
            description: "Explore epilepsy, its symptoms, causes, and how clean air supports recovery.",
            sectionCount: "4 sections",
            bannerSymbol: "brain.head.profile",
            gradientColors: [Color(red: 0.31, green: 0.65, blue: 0.95), Color(red: 0.61, green: 0.77, blue: 0.96)]
        ),
        Article(
            title: "Why AQI Matters in India",
            subtitle: "Daily exposure explained",
            description: "Understand how AQI is measured and when to reduce outdoor activity.",
            sectionCount: "5 sections",
            bannerSymbol: "sun.haze.fill",
            gradientColors: [Color(red: 0.9, green: 0.63, blue: 0.26), Color(red: 0.95, green: 0.42, blue: 0.2)]
        )
    ]
}
