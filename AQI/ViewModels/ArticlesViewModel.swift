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
            body: "Cardiovascular disease (CVD) refers to conditions that affect the heart and blood vessels. Air pollution, especially fine particulate matter (PM2.5), can increase inflammation and oxidative stress, elevating CVD risk.\n\nWhat to know:\n• Maintain regular checkups and monitor blood pressure.\n• Prioritize indoor exercise on high‑AQI days.\n• Use masks and air purifiers when necessary.",
            sectionCount: "6 sections",
            bannerSymbol: "heart.fill",
            gradientColors: [Color(red: 0.65, green: 0.06, blue: 0.18), Color(red: 0.9, green: 0.27, blue: 0.35)],
            kind: .cardio
        ),
        Article(
            title: "Epilepsy Insights",
            subtitle: "Brain health & pollution",
            description: "Explore epilepsy, its symptoms, causes, and how clean air supports recovery.",
            body: "Epilepsy is a neurological disorder characterized by recurrent seizures. Some studies suggest air pollution may correlate with increased seizure frequency for sensitive individuals.\n\nTips:\n• Keep medication schedules consistent.\n• Avoid strenuous outdoor activity on poor AQI days.\n• Consult your neurologist about triggers.",
            sectionCount: "4 sections",
            bannerSymbol: "brain.head.profile",
            gradientColors: [Color(red: 0.31, green: 0.65, blue: 0.95), Color(red: 0.61, green: 0.77, blue: 0.96)],
            kind: .epilepsy
        ),
        Article(
            title: "Why AQI Matters in India",
            subtitle: "Daily exposure explained",
            description: "Understand how AQI is measured and when to reduce outdoor activity.",
            body: "The Air Quality Index (AQI) translates pollutant concentrations into an easy scale. In many Indian cities, seasonal changes and traffic contribute to elevated PM2.5 and NO2.\n\nKey points:\n• Check AQI before outdoor plans.\n• Prefer early mornings or post‑rain periods for activities.\n• Use N95/FFP2 masks when AQI is high.",
            sectionCount: "5 sections",
            bannerSymbol: "sun.haze.fill",
            gradientColors: [Color(red: 0.9, green: 0.63, blue: 0.26), Color(red: 0.95, green: 0.42, blue: 0.2)],
            kind: .aqiIndia
        )
    ]
}
