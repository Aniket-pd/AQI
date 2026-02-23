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
                title: "What Exactly Is PM2.5?",
                bodyText: "Every time you take a breath, you inhale a mixture of gases and tiny particles suspended in the air. Among them is PM2.5 — particulate matter that measures 2.5 micrometers or smaller in diameter.\n\nTo understand how small that is, consider this: a human hair is about 70 micrometers wide. PM2.5 is nearly thirty times smaller. These particles are invisible under normal conditions, yet they are present in the air around us — especially in urban environments.\n\nBecause of their size, PM2.5 particles behave differently from larger dust. They remain suspended in the air for longer periods and travel greater distances."
            )

            ArticleSectionView(
                title: "Why Size Makes It Dangerous",
                bodyText: "The danger of PM2.5 lies in its scale.\n\nLarger particles are usually trapped by the nose or throat. PM2.5 bypasses these defenses. It travels deep into the lungs and may enter the bloodstream. Over time, repeated exposure can increase the risk of respiratory illness, cardiovascular disease, and stroke.\n\nThe World Health Organization reports that air pollution contributes to millions of premature deaths each year, and fine particulate matter is one of the primary causes.\n\nThe effects are not immediate. They accumulate gradually through long-term exposure."
            )

            ArticleSectionView(
                title: "Where Does PM2.5 Come From?",
                bodyText: "PM2.5 is produced by both human activity and natural processes.\n\nIn cities, common sources include vehicle exhaust, power plants, industrial emissions, construction activity, and burning of fuels. Natural sources such as wildfires and dust storms can also increase particle levels.\n\nBecause these particles are extremely small, they can travel across cities and even between countries. This makes air pollution a regional and global issue — not just a local one.\n\nThe United Nations Environment Programme emphasizes that understanding air pollution is the first step toward reducing its impact."
            )

            ArticleSectionView(
                title: "Why You May Not Notice It",
                bodyText: "One of the most challenging aspects of PM2.5 is that it is often invisible.\n\nWhile heavy pollution can appear as smog, harmful levels may still exist even when the sky looks clear. Human perception is not a reliable tool for detecting fine particles.\n\nThis is why monitoring systems measure air quality scientifically. The Air Quality Index (AQI) translates these measurements into understandable categories, helping individuals make informed decisions.\n\nRelying on AQI data is far more accurate than judging air quality visually."
            )

            ArticleARSection(
                title: "Seeing the Invisible: AR Visualization",
                bodyText: "Understanding microscopic particles through text alone can be abstract. To make this concept easier to grasp, this app includes an augmented reality (AR) visualization.\n\nWhen you tap Open AR, a visual model of floating particles will appear in your physical space. This experience is designed to support learning by helping you visualize how fine particulate matter may exist around you.\n\nThe AR particles are educational representations. They are not to scale and do not reflect the real-time concentration of PM2.5 in your surroundings. For accurate air quality information, always consult official AQI sources such as the United States Environmental Protection Agency or other government monitoring agencies.\n\nThe purpose of this feature is simple: to transform an invisible scientific concept into something understandable.",
                buttonTitle: "Open AR"
            ) {
                showAR = true
            }

            ReferenceLinksSection(
                title: "References",
                references: [
                    ReferenceLink(
                        title: "United Nations Environment Programme – Air pollution: Know your enemy",
                        url: URL(string: "https://www.unep.org/news-and-stories/story/air-pollution-know-your-enemy")!
                    ),
                    ReferenceLink(
                        title: "World Health Organization – Air Pollution Overview",
                        url: URL(string: "https://www.who.int/health-topics/air-pollution")!
                    ),
                    ReferenceLink(
                        title: "United States Environmental Protection Agency – Particulate Matter (PM) Basics",
                        url: URL(string: "https://www.epa.gov/pm-pollution")!
                    )
                ]
            )
        }
        .fullScreenCover(isPresented: $showAR) {
            PM25OverlayView()
        }
    }
}
