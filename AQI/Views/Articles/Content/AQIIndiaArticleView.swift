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
                title: "What is AQI?",
                bodyText: "The Air Quality Index (AQI) is a standardized scale that translates complex air pollutant concentrations into an easy to understand score from 0 to 500. Lower is better. Scores are grouped into ranges with color codes that indicate potential health impacts for the general public and for sensitive groups."
            )

            ArticleSectionView(
                title: "What is PM2.5?",
                bodyText: "PM2.5 are fine particulate matter with a diameter of 2.5 micrometers or less—small enough to penetrate deep into the lungs and even enter the bloodstream. Long-term exposure is associated with heart and lung diseases."
            )

            ArticleSectionView(
                title: "How is AQI calculated?",
                bodyText: "Regulatory agencies compute a sub-index for each pollutant (PM2.5, PM10, O3, NO2, SO2, CO). The overall AQI is the maximum of these sub-indices for the monitoring period. The color category is determined by thresholds defined by national standards."
            )

            ArticleSectionView(
                title: "Health impacts",
                bodyText: "As AQI increases, so does the likelihood of respiratory and cardiovascular symptoms. Sensitive groups (children, older adults, pregnant people, and those with chronic conditions) may experience effects at lower AQI levels."
            )

            ArticleSectionView(
                title: "Reduce exposure",
                bodyText: "Monitor AQI in your area and plan outdoor activities when levels are lower.\n- Use well-fitted masks on high AQI days.\n- Close windows and use air purifiers indoors.\n- Prefer public transport or active travel when air is cleaner."
            )
        }
    }
}

