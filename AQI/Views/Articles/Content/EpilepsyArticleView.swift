//
//  EpilepsyArticleView.swift
//  AQI
//
//  Dedicated content view for the temperature inversion article.
//

import SwiftUI

struct EpilepsyArticleView: View {
    @State private var showAR = false
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ArticleSectionView(
                title: "The Air Is Meant to Move",
                bodyText: "During the day, sunlight warms the ground. The ground warms the air above it. That warm air rises and mixes with the atmosphere. This mixing spreads pollution upward and helps prevent it from staying concentrated near the surface.\n\nThis daily stirring acts like natural ventilation for cities."
            )

            ArticleSectionView(
                title: "When the Pattern Reverses",
                bodyText: "At night, the ground cools quickly after sunset. The air near the surface cools faster than the air above it. A layer of warmer air settles over cooler air near the ground. This is called a temperature inversion.\n\nYou can imagine it as a lid.\n\nThe cooler air below becomes stable and cannot rise easily. Vertical mixing weakens. Pollution released from traffic and daily activity remains trapped close to where people breathe."
            )

            ArticleSectionView(
                title: "A Smaller Volume of Air",
                bodyText: "In the daytime, the mixing layer may extend about one kilometer upward. At night, it can shrink to roughly one hundred meters.\n\nThe same emissions now enter a much smaller space.\n\nWhen the volume of air decreases, concentration increases. This is why smog often appears worse before sunrise, when the inversion is strongest and winds are calm.\n\nCooler nighttime air also increases humidity. Fine particles scatter light more effectively in humid conditions, which can make haze appear thicker.\n\nThese invisible layers shape the air we experience — even if we cannot see them directly."
            )

            ArticleARSection(
                title: "Seeing the Invisible (AR Experience)",
                bodyText: "The AR experience in this app helps you visualize this daily change.\n\nAs you move the time slider, you will see how the “lid” forms at night and lifts during the day. You will see how the mixing layer shrinks and expands as surface heating changes.\n\nThis visualization is conceptual and educational. It is designed to build intuition about how temperature inversions trap pollution. It does not represent exact real-time pollution levels, forecasts, or measurements for your location.\n\nIt shows the pattern — not a prediction.",
                buttonTitle: "Start Inversion AR"
            ) {
                showAR = true
            }

            ArticleSectionView(
                title: "Why It Matters",
                bodyText: "Smog is not a single pollutant. Fine particles such as PM2.5 are often the main concern during inversion events because they can travel deep into the lungs and bloodstream. Ozone behaves differently and often peaks later in the afternoon because it forms in sunlight.\n\nWhen pollution remains near the surface, exposure increases. Fine particles have been linked to respiratory and cardiovascular disease, and some inversion episodes have been associated with higher emergency visits.\n\nChildren, older adults, pregnant individuals, and people with heart or lung conditions are generally more vulnerable.\n\nCalm air is not always clean air."
            )

            ArticleSectionView(
                title: "What You Can Do",
                bodyText: "Start by checking your local air quality.\n\nIf particle pollution (PM2.5) is high, early morning may be one of the worst times because the mixing layer is still shallow. Waiting until later in the day, when mixing improves, may reduce exposure.\n\nIf ozone is the main concern, afternoon may be worse than morning because ozone forms in sunlight.\n\nYou can reduce exposure by limiting time outdoors during poor air quality, lowering exercise intensity, avoiding heavy traffic areas, and improving indoor air filtration.\n\nUnderstanding the daily pattern helps you make better decisions."
            )

            ArticleSectionView(
                title: "References",
                bodyText: "• World Health Organization (WHO) – Air Quality Guidelines\nhttps://www.who.int/news-room/feature-stories/detail/what-are-the-who-air-quality-guidelines\n\n• WHO – Ambient Air Pollution Fact Sheet\nhttps://www.who.int/news-room/fact-sheets/detail/ambient-(outdoor)-air-quality-and-health\n\n• United States Environmental Protection Agency (EPA) – PM Health Effects\nhttps://www.epa.gov/pm-pollution/health-and-environmental-effects-particulate-matter-pm\n\n• EPA – Ground-Level Ozone Basics\nhttps://www.epa.gov/ground-level-ozone-pollution/ground-level-ozone-basics\n\n• AirNow – AQI Technical Assistance Document\nhttps://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf\n\n• National Weather Service – Inversion Overview\nhttps://www.weather.gov/media/lzk/inversion101.pdf\n\n• NOAA – Temperature Inversion Glossary\nhttps://www.noaa.gov/jetstream/appendix/weather-glossary-i"
            )
        }
        .fullScreenCover(isPresented: $showAR) {
            InversionOverlayView()
        }
    }
}
