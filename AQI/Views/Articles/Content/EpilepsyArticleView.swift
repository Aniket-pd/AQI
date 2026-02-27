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
                bodyText: "During the day, sunlight warms the ground. The ground warms the air above it. That warm air rises and mixes with the atmosphere. This mixing spreads pollution upward and helps prevent it from staying concentrated near the surface.This daily stirring acts like natural ventilation for cities.\nIn normal conditions, warm air near the ground rises and mixes with cooler air above.\nDuring a temperature inversion, a layer of warm air sits above cooler air near the surface, preventing that upward movement.\nLook at the diagrams below and notice how the direction of air movement changes."
            )
            // MARK: - INSERT ILLUSTRATION 1 (Daytime Mixing Visual)
            DaytimeMixingIllustrationView()

            ArticleSectionView(
                title: "When the Pattern Reverses",
                bodyText: "At night, the ground cools quickly after sunset. The air near the surface cools faster than the air above it. A layer of warmer air settles over cooler air near the ground. This is called a temperature inversion.\n\nYou can imagine it as a lid.\n\nThe cooler air below becomes stable and cannot rise easily. Vertical mixing weakens. Pollution released from traffic and daily activity remains trapped close to where people breathe."
            )
            // MARK: - INSERT INTERACTIVE TOGGLE 1 (Day vs Night Inversion)
            InversionToggleIllustrationView()

            ArticleSectionView(
                title: "A Smaller Volume of Air",
                bodyText: "In the daytime, the mixing layer may extend about one kilometer upward. At night, it can shrink to roughly one hundred meters.\n\nThe same emissions now enter a much smaller space.\n\nWhen the volume of air decreases, concentration increases. This is why smog often appears worse before sunrise, when the inversion is strongest and winds are calm.\n\nCooler nighttime air also increases humidity. Fine particles scatter light more effectively in humid conditions, which can make haze appear thicker.\n\nThese invisible layers shape the air we experience even if we cannot see them directly."
            )
            // MARK: - INSERT MICRO SIMULATION (Mixing Layer Shrink Simulation)
            /*
             MICRO SIMULATION SPECIFICATION:

             Goal:
             Visually demonstrate that when the mixing layer height shrinks at night,
             the same emissions occupy a smaller air volume, increasing concentration.

             Simulation Behavior:
             - Display a city silhouette at the bottom.
             - Above it, show a transparent "air box" representing the mixing layer.
             - Populate the air box with a fixed number of grey particle dots.
             - Add a vertical slider labeled "Time of Day" (Day → Night).

             Interaction:
             - As the slider moves downward (Day → Night):
                 • The height of the air box shrinks smoothly.
                 • The SAME number of particles remain.
                 • Particle vertical positions compress proportionally.
                 • Background subtly transitions from light (day) to dark (night).
                 • Mixing Height label updates dynamically (1000m → 100m).
                 • Concentration label updates (Low → Medium → High).

             Constraints:
             - No wind simulation.
             - No humidity physics.
             - No charts.
             - Keep minimal and educational.
             - Smooth 0.6s animation when transitioning states.
             - Focus on intuitive visual density change.

             This is a conceptual educational simulation, not real data.
            */

            InversionARSectionView(
                title: "Seeing the Invisible (AR Experience)",
                bodyText: "The AR experience in this app helps you visualize this daily change.\n\nAs you move the time slider, you will see how the “lid” forms at night and lifts during the day. You will see how the mixing layer shrinks and expands as surface heating changes.\n\nThis visualization is conceptual and educational. It is designed to build intuition about how temperature inversions trap pollution. It does not represent exact real-time pollution levels, forecasts, or measurements for your location.\n\nIt shows the pattern not a prediction.",
                imageName: "InversionAR",
                quoteText: "Visualize how invisible air layers shape the air around you.",
                buttonTitle: "Open AR"
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

            ReferenceLinksSection(
                title: "References",
                buttonTitle: "Reference Link",
                references: [
                    ReferenceLink(
                        title: "World Health Organization (WHO) – Air Quality Guidelines",
                        url: URL(string: "https://www.who.int/news-room/feature-stories/detail/what-are-the-who-air-quality-guidelines")!
                    ),
                    ReferenceLink(
                        title: "WHO – Ambient Air Pollution Fact Sheet",
                        url: URL(string: "https://www.who.int/news-room/fact-sheets/detail/ambient-(outdoor)-air-quality-and-health")!
                    ),
                    ReferenceLink(
                        title: "United States Environmental Protection Agency (EPA) – PM Health Effects",
                        url: URL(string: "https://www.epa.gov/pm-pollution/health-and-environmental-effects-particulate-matter-pm")!
                    ),
                    ReferenceLink(
                        title: "EPA – Ground-Level Ozone Basics",
                        url: URL(string: "https://www.epa.gov/ground-level-ozone-pollution/ground-level-ozone-basics")!
                    ),
                    ReferenceLink(
                        title: "AirNow – AQI Technical Assistance Document",
                        url: URL(string: "https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf")!
                    ),
                    ReferenceLink(
                        title: "National Weather Service – Inversion Overview",
                        url: URL(string: "https://www.weather.gov/media/lzk/inversion101.pdf")!
                    ),
                    ReferenceLink(
                        title: "NOAA – Temperature Inversion Glossary",
                        url: URL(string: "https://www.noaa.gov/jetstream/appendix/weather-glossary-i")!
                    )
                ]
            )
        }
        .fullScreenCover(isPresented: $showAR) {
            InversionOverlayView()
        }
    }
}

private struct EditorialCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.45), Color.primary.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

private struct DaytimeMixingIllustrationView: View {
    var body: some View {
        EditorialCard {
            Image("inversionLID")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

private struct InversionToggleIllustrationView: View {
    var body: some View {
        EditorialCard {
            Image("SmogLayer")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}

private struct InversionARSectionView: View {
    let title: String
    let bodyText: String
    let imageName: String
    let quoteText: String
    let buttonTitle: String
    var action: () -> Void

    private var paragraphs: [String] {
        bodyText
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(paragraphs.indices, id: \.self) { index in
                    Text(paragraphs[index])
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            Text(quoteText)
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)

            HStack {
                Spacer()
                Button(action: action) {
                    Label(buttonTitle, systemImage: "arkit")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .font(.title3.weight(.semibold))
                .controlSize(.large)
                .frame(minWidth: 180)
                .accessibilityHint("Opens an AR experience")
                Spacer()
            }
            .padding(.top, 2)
        }
    }
}
