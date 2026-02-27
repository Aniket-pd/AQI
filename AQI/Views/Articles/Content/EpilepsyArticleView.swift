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
            // MARK: - INSERT ILLUSTRATION 2 (Mixing Layer Comparison)
            MixingLayerComparisonView()
            VolumeConceptCheckView()

            // MARK: - INSERT PREVIEW ILLUSTRATION (AR Preview Model)
            InversionPreviewIllustrationView()
            ArticleARSection(
                title: "Seeing the Invisible (AR Experience)",
                bodyText: "The AR experience in this app helps you visualize this daily change.\n\nAs you move the time slider, you will see how the “lid” forms at night and lifts during the day. You will see how the mixing layer shrinks and expands as surface heating changes.\n\nThis visualization is conceptual and educational. It is designed to build intuition about how temperature inversions trap pollution. It does not represent exact real-time pollution levels, forecasts, or measurements for your location.\n\nIt shows the pattern not a prediction.",
                buttonTitle: "Start Inversion AR"
            ) {
                showAR = true
            }

            ArticleSectionView(
                title: "Why It Matters",
                bodyText: "Smog is not a single pollutant. Fine particles such as PM2.5 are often the main concern during inversion events because they can travel deep into the lungs and bloodstream. Ozone behaves differently and often peaks later in the afternoon because it forms in sunlight.\n\nWhen pollution remains near the surface, exposure increases. Fine particles have been linked to respiratory and cardiovascular disease, and some inversion episodes have been associated with higher emergency visits.\n\nChildren, older adults, pregnant individuals, and people with heart or lung conditions are generally more vulnerable.\n\nCalm air is not always clean air."
            )
            // MARK: - INSERT INFOGRAPHIC (Health Impact Visual)
            HealthImpactInfographicView()

            ArticleSectionView(
                title: "What You Can Do",
                bodyText: "Start by checking your local air quality.\n\nIf particle pollution (PM2.5) is high, early morning may be one of the worst times because the mixing layer is still shallow. Waiting until later in the day, when mixing improves, may reduce exposure.\n\nIf ozone is the main concern, afternoon may be worse than morning because ozone forms in sunlight.\n\nYou can reduce exposure by limiting time outdoors during poor air quality, lowering exercise intensity, avoiding heavy traffic areas, and improving indoor air filtration.\n\nUnderstanding the daily pattern helps you make better decisions."
            )
            // MARK: - INSERT DECISION SIMULATION (Best Time to Go Outside)
            OutdoorTimingDecisionView()

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
    @State private var animateFlow = false
    private let particlePoints: [CGPoint] = [
        CGPoint(x: 0.15, y: 0.77), CGPoint(x: 0.24, y: 0.75), CGPoint(x: 0.35, y: 0.73), CGPoint(x: 0.44, y: 0.78),
        CGPoint(x: 0.56, y: 0.76), CGPoint(x: 0.66, y: 0.74), CGPoint(x: 0.77, y: 0.79), CGPoint(x: 0.84, y: 0.72),
        CGPoint(x: 0.28, y: 0.69), CGPoint(x: 0.61, y: 0.67)
    ]

    var body: some View {
        EditorialCard {
            GeometryReader { geo in
                let size = geo.size
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.cyan.opacity(0.2), Color.blue.opacity(0.1), Color.indigo.opacity(0.08)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    Circle()
                        .fill(Color.yellow.opacity(0.2))
                        .frame(width: 110, height: 110)
                        .offset(x: -size.width * 0.34, y: -size.height * 0.34)
                        .blur(radius: 8)

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.green.opacity(0.2))
                        .frame(height: size.height * 0.2)
                        .offset(y: size.height * 0.41)

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.14), Color.cyan.opacity(0.08)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: size.width * 0.86, height: size.height * 0.7)
                        .offset(y: -size.height * 0.04)

                    Circle()
                        .fill(Color.yellow.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color.yellow.opacity(0.45), lineWidth: 1.2))
                        .offset(x: -size.width * 0.34, y: -size.height * 0.35)

                    ForEach(0..<8, id: \.self) { ray in
                        Capsule()
                            .fill(Color.yellow.opacity(0.28))
                            .frame(width: 2.4, height: 11)
                            .offset(y: -17)
                            .rotationEffect(.degrees(Double(ray) * 45))
                            .offset(x: -size.width * 0.34, y: -size.height * 0.35)
                    }

                    ForEach(0..<3, id: \.self) { index in
                        Image(systemName: "arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.orange.opacity(0.68))
                        .offset(
                            x: CGFloat(index - 1) * size.width * 0.19,
                            y: size.height * (animateFlow ? -0.18 : 0.04)
                        )
                        .opacity(animateFlow ? 0.95 : 0.45)
                        .animation(
                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(Double(index) * 0.12),
                            value: animateFlow
                        )
                    }

                    ForEach(Array(particlePoints.enumerated()), id: \.offset) { index, point in
                        Circle()
                            .fill(Color.gray.opacity(0.45))
                            .frame(width: 4.8, height: 4.8)
                            .position(
                                x: point.x * size.width,
                                y: (point.y * size.height) + (animateFlow ? -38 - CGFloat(index % 4) * 3 : 0)
                            )
                            .opacity(animateFlow ? 0.62 : 0.9)
                            .animation(
                                .easeInOut(duration: 2.1).repeatForever(autoreverses: true).delay(Double(index) * 0.07),
                                value: animateFlow
                            )
                    }

                    HStack {
                        Text("Tall mixing layer")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                        Spacer()
                    }
                    .padding(10)
                }
            }
            .frame(height: 240)
        }
        .onAppear {
            animateFlow = true
        }
    }
}

private struct InversionToggleIllustrationView: View {
    private enum TimeMode: String, CaseIterable, Identifiable {
        case day = "Day"
        case night = "Night"
        var id: String { rawValue }
    }

    @State private var mode: TimeMode = .day
    private let particlePoints: [CGPoint] = [
        CGPoint(x: 0.14, y: 0.77), CGPoint(x: 0.23, y: 0.73), CGPoint(x: 0.31, y: 0.75), CGPoint(x: 0.39, y: 0.72),
        CGPoint(x: 0.5, y: 0.74), CGPoint(x: 0.59, y: 0.71), CGPoint(x: 0.67, y: 0.75), CGPoint(x: 0.76, y: 0.72),
        CGPoint(x: 0.86, y: 0.76)
    ]
    @State private var breathe = false

    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Day vs Night Mixing")
                    .font(.headline)

                Picker("Time", selection: $mode.animation(.easeInOut(duration: 0.35))) {
                    ForEach(TimeMode.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)

                GeometryReader { geo in
                    let size = geo.size
                    let mixingHeight = mode == .day ? size.height * 0.66 : size.height * 0.24
                    let mixingTopY = size.height * 0.32 - mixingHeight / 2
                    let lidY = size.height * 0.36
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        mode == .day ? Color.cyan.opacity(0.2) : Color.indigo.opacity(0.3),
                                        mode == .day ? Color.blue.opacity(0.1) : Color.black.opacity(0.28)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        Circle()
                            .fill((mode == .day ? Color.yellow : Color.white).opacity(0.6))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke((mode == .day ? Color.yellow : Color.white).opacity(0.35), lineWidth: 1)
                            )
                            .offset(x: mode == .day ? -size.width * 0.36 : size.width * 0.35, y: -size.height * 0.34)
                            .animation(.easeInOut(duration: 0.35), value: mode)

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.16), Color.cyan.opacity(0.08)],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .frame(width: size.width * 0.86, height: mixingHeight)
                            .offset(y: mixingTopY)
                            .animation(.easeInOut(duration: 0.45), value: mixingHeight)

                        if mode == .night {
                            Capsule()
                                .fill(Color.orange.opacity(0.34))
                                .frame(width: size.width * 0.84, height: 11)
                                .offset(y: lidY)
                                .transition(.opacity.combined(with: .scale))
                                .overlay(
                                    Text("Warm lid")
                                        .font(.caption2.weight(.medium))
                                        .foregroundStyle(.secondary)
                                        .offset(y: lidY - 14)
                                )
                        }

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green.opacity(0.2))
                            .frame(height: size.height * 0.22)
                            .offset(y: size.height * 0.4)

                        ForEach(Array(particlePoints.enumerated()), id: \.offset) { index, point in
                            Circle()
                                .fill(Color.gray.opacity(mode == .day ? 0.35 : 0.6))
                                .frame(width: 6, height: 6)
                                .position(
                                    x: point.x * size.width,
                                    y: mode == .day
                                        ? point.y * size.height - 44 - (breathe ? CGFloat(index % 3) * 5 : 0)
                                        : point.y * size.height - (breathe ? CGFloat(index % 2) * 2 : 0)
                                )
                                .animation(.easeInOut(duration: 0.5), value: mode)
                                .animation(
                                    .easeInOut(duration: 1.6).repeatForever(autoreverses: true).delay(Double(index) * 0.08),
                                    value: breathe
                                )
                        }

                        HStack {
                            Text(mode == .day ? "Strong vertical mixing" : "Stable trapped layer")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                            Spacer()
                        }
                        .padding(10)
                    }
                }
                .frame(height: 200)

                Text(mode == .day ? "Daytime heating deepens the mixing layer and helps pollutants disperse." : "At night, a warmer layer aloft acts like a lid and keeps pollution near the surface.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .animation(.easeInOut(duration: 0.35), value: mode)
            }
        }
        .frame(height: 280)
        .onAppear {
            breathe = true
        }
    }
}

private struct MixingLayerComparisonView: View {
    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Mixing Layer Comparison")
                    .font(.headline)

                HStack(spacing: 10) {
                    MixingLayerColumnView(
                        title: "Daytime",
                        subtitle: "~1 km layer",
                        layerFraction: 0.82,
                        particleCount: 8,
                        layerTint: Color.cyan
                    )
                    MixingLayerColumnView(
                        title: "Nighttime",
                        subtitle: "~100 m layer",
                        layerFraction: 0.28,
                        particleCount: 16,
                        layerTint: Color.indigo
                    )
                }

                HStack(spacing: 8) {
                    Label("Larger air volume", systemImage: "arrow.up.left.and.arrow.down.right")
                    Label("Higher concentration when compressed", systemImage: "aqi.low")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
    }
}

private struct MixingLayerColumnView: View {
    let title: String
    let subtitle: String
    let layerFraction: CGFloat
    let particleCount: Int
    let layerTint: Color

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            GeometryReader { geo in
                let size = geo.size
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(.tertiarySystemFill))

                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [layerTint.opacity(0.2), layerTint.opacity(0.1)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(height: size.height * layerFraction)

                    ForEach(0..<4, id: \.self) { mark in
                        Path { path in
                            let y = size.height * CGFloat(mark + 1) / 5.0
                            path.move(to: CGPoint(x: size.width * 0.12, y: y))
                            path.addLine(to: CGPoint(x: size.width * 0.88, y: y))
                        }
                        .stroke(Color.primary.opacity(0.08), style: StrokeStyle(lineWidth: 0.7, dash: [3, 3]))
                    }

                    ForEach(0..<particleCount, id: \.self) { idx in
                        let x = 0.18 + (Double(idx % 4) * 0.19)
                        let y = 0.83 - (Double(idx / 4) * (Double(layerFraction) / 4.1))
                        Circle()
                            .fill(Color.gray.opacity(0.44))
                            .frame(width: 4.8, height: 4.8)
                            .position(x: x * size.width, y: y * size.height)
                    }
                }
            }
            .frame(height: 155)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct VolumeConceptCheckView: View {
    private enum Answer {
        case decreases
        case increases
    }

    @State private var selection: Answer?
    @State private var revealFeedback = false

    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Concept Check")
                    .font(.headline)
                Text("If emissions stay the same, what happens when the mixing layer shrinks?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    conceptButton(title: "Concentration decreases", answer: .decreases)
                    conceptButton(title: "Concentration increases", answer: .increases)
                }

                if let selection, revealFeedback {
                    HStack(spacing: 8) {
                        Image(systemName: selection == .increases ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(selection == .increases ? Color.green : Color.orange)
                        Text(selection == .increases ? "Correct. The same emissions in a smaller air volume produce higher concentration." : "Not quite. Shrinking the air volume raises concentration when emissions are unchanged.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(selection == .increases ? Color.green.opacity(0.12) : Color.orange.opacity(0.14))
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
    }

    private func conceptButton(title: String, answer: Answer) -> some View {
        let isSelected = selection == answer
        let isCorrect = answer == .increases
        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selection = answer
                revealFeedback = true
            }
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                if isSelected {
                    Image(systemName: isCorrect ? "checkmark" : "xmark")
                        .font(.caption.weight(.bold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(
                        isSelected ? (isCorrect ? Color.green.opacity(0.14) : Color.orange.opacity(0.16)) : Color(.tertiarySystemFill)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? (isCorrect ? Color.green.opacity(0.4) : Color.orange.opacity(0.4)) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct InversionPreviewIllustrationView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Inversion Preview")
                    .font(.headline)

                GeometryReader { geo in
                    let size = geo.size
                    let layerHeight = size.height * (0.24 + 0.34 * phase)
                    let arcCenter = CGPoint(x: size.width / 2, y: size.height * 1.08)
                    let arcRadius = size.width * 0.46
                    let angle = Angle.degrees(210 + Double(phase) * 120).radians
                    let sunX = arcCenter.x + CGFloat(cos(angle)) * arcRadius
                    let sunY = arcCenter.y + CGFloat(sin(angle)) * arcRadius

                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.cyan.opacity(0.12), Color.blue.opacity(0.08)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )

                        Path { path in
                            path.addArc(
                                center: CGPoint(x: size.width / 2, y: size.height * 1.08),
                                radius: size.width * 0.46,
                                startAngle: .degrees(205),
                                endAngle: .degrees(335),
                                clockwise: false
                            )
                        }
                        .stroke(Color.yellow.opacity(0.45), style: StrokeStyle(lineWidth: 2, lineCap: .round))

                        Circle()
                            .fill(Color.yellow.opacity(0.35))
                            .frame(width: 20, height: 20)
                            .position(x: sunX, y: sunY)
                            .shadow(color: Color.yellow.opacity(0.45), radius: 8, x: 0, y: 0)

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: size.width * 0.88, height: layerHeight)
                            .offset(y: size.height * 0.33 - layerHeight / 2)
                            .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: phase)

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.green.opacity(0.15))
                            .frame(height: size.height * 0.19)
                            .offset(y: size.height * 0.4)

                        HStack {
                            Text("Preview: daily expansion/compression")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                            Spacer()
                        }
                        .padding(10)
                    }
                }
                .frame(height: 170)

                Text("The mixing layer rises with daytime heating and compresses overnight.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear {
            phase = 1
        }
    }
}

private struct HealthImpactInfographicView: View {
    private let items: [(symbol: String, title: String, detail: String, tint: Color)] = [
        ("lungs.fill", "Lungs", "Irritation and inflammation", Color.teal),
        ("heart.fill", "Heart", "Cardiovascular strain", Color.red),
        ("figure.child", "Children", "Higher breathing-rate risk", Color.blue),
        ("figure.seated.side", "Older Adults", "Greater vulnerability", Color.orange)
    ]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Health Impact Overview")
                    .font(.headline)

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(items, id: \.title) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Circle()
                                .fill(item.tint.opacity(0.16))
                                .frame(width: 34, height: 34)
                                .overlay(
                                    Image(systemName: item.symbol)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(item.tint.opacity(0.95))
                                )

                            Text(item.title)
                                .font(.subheadline.weight(.semibold))

                            Text(item.detail)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, minHeight: 98, alignment: .leading)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.tertiarySystemFill))
                        )
                    }
                }
            }
        }
    }
}

private struct OutdoorTimingDecisionView: View {
    private enum Choice {
        case morning
        case afternoon
    }

    @State private var choice: Choice?
    @State private var animateBars = false

    var body: some View {
        EditorialCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Outdoor Timing Decision")
                    .font(.headline)
                Text("AQI is high and morning air is calm. You plan to jog once today.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    timingButton(title: "Morning", current: .morning)
                    timingButton(title: "Afternoon", current: .afternoon)
                }

                if let choice {
                    HStack(spacing: 8) {
                        Image(systemName: choice == .afternoon ? "checkmark.seal.fill" : "exclamationmark.circle.fill")
                            .foregroundStyle(choice == .afternoon ? Color.green : Color.orange)
                        Text(choice == .afternoon ? "Better option for PM2.5-heavy calm mornings." : "Higher likely exposure in calm morning conditions.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.opacity)

                    VStack(alignment: .leading, spacing: 8) {
                        exposureBar(title: "Morning exposure", value: 0.86, emphasize: choice == .morning, animate: animateBars)
                        exposureBar(title: "Afternoon exposure", value: 0.48, emphasize: choice == .afternoon, animate: animateBars)
                    }
                    .transition(.opacity)

                    Text(choice == .afternoon ? "Usually better for PM2.5-heavy days: daytime mixing lifts the layer and reduces near-ground concentration." : "Morning can be worse for PM2.5 when inversion is strongest and vertical mixing is weak.")
                        .font(.caption)
                        .foregroundStyle(choice == .afternoon ? Color.green : Color.orange)
                        .transition(.opacity)
                }
            }
        }
    }

    private func timingButton(title: String, current: Choice) -> some View {
        let isSelected = choice == current
        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                choice = current
                animateBars = false
            }
            withAnimation(.easeInOut(duration: 0.35).delay(0.05)) {
                animateBars = true
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: current == .morning ? "sunrise.fill" : "sun.max.fill")
                    .font(.caption)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? Color.blue.opacity(0.16) : Color(.tertiarySystemFill))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isSelected ? Color.blue.opacity(0.38) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func exposureBar(title: String, value: CGFloat, emphasize: Bool, animate: Bool) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(Int(value * 100))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                    Capsule()
                        .fill(emphasize ? Color.blue.opacity(0.58) : Color.gray.opacity(0.35))
                        .frame(width: geo.size.width * (animate ? value : 0))
                        .animation(.easeInOut(duration: 0.35), value: animate)
                }
            }
            .frame(height: 9)
        }
    }
}
