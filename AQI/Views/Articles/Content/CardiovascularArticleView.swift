//
//  CardiovascularArticleView.swift
//  AQI
//
//  Dedicated content view for the cardiovascular article.
//

import SwiftUI

struct CardiovascularArticleView: View {
    @State private var showAR = false
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ArticleSectionView(
                title: "Why walking steadiness goes down",
                bodyText: "Changes in strength, balance systems, medication effects, or underlying conditions can reduce walking steadiness over time. Identifying the cause helps target the right interventions."
            )

            ArticleSectionView(
                title: "Air quality and the heart",
                bodyText: "Exposure to PM2.5 and ozone is linked with increased blood pressure, inflammation, and a higher risk of cardiovascular events. On high AQI days, reduce strenuous outdoor activity and consider indoor alternatives."
            )

            ArticleSectionView(
                title: "Exercises that may help",
                bodyText: "- Strength: chair squats, wall push-ups.\n- Balance: single-leg stands, heel-to-toe walk.\n- Endurance: brisk walking when AQI is favorable.\nConsult a clinician before starting a new routine."
            )

            ArticleSectionView(
                title: "When to talk to a doctor",
                bodyText: "If you notice a rapid decline in steadiness, chest discomfort, shortness of breath, or dizziness, seek medical advice promptly."
            )

            ArticleARSection(
                title: "Try This in AR",
                bodyText: "Visualize PM2.5 particles and understand how air quality can impact cardio fitness. Use your camera to place the particle simulation in your environment.",
                buttonTitle: "Start PM2.5 AR"
            ) {
                showAR = true
            }
        }
        .fullScreenCover(isPresented: $showAR) {
            PM25OverlayView()
        }
    }
}
