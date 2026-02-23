//
//  SignalDetailView.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct SignalDetailView: View {
    let title: String
    let subtitle: String
    let sections: [SignalDetailSection]
    let accentColor: Color
    let iconName: String
    let sources: [String]

    // Track scroll to drive the header shade fade
    @State private var scrollY: CGFloat = 0
    @Environment(\.colorScheme) private var scheme

    init(title: String,
         subtitle: String,
         sections: [SignalDetailSection],
         accentColor: Color,
         iconName: String,
         sources: [String] = []) {
        self.title = title
        self.subtitle = subtitle
        self.sections = sections
        self.accentColor = accentColor
        self.iconName = iconName
        self.sources = sources
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Base background stays grouped
            Color(.systemGroupedBackground).ignoresSafeArea()

            // Apple Health–style top gradient shade behind nav and header
            TopShade(accentColor: accentColor, progress: shadeProgress)
                .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Invisible tracker for scroll offset
                        Color.clear
                            .frame(height: 0)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: ViewOffsetKey.self, value: proxy.frame(in: .named("signalScroll")).minY)
                                }
                            )
                        // Header: icon + title on one line; subtitle below
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center, spacing: 12) {
                                Image(systemName: iconName)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(colorForScheme)
                                Text(title)
                                    .font(.title2.bold())
                                    .foregroundStyle(.primary)
                            }
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    
                    // Sections
                    VStack(spacing: 14) {
                        ForEach(sections) { section in
                            SignalSectionRow(accentColor: accentColor, section: section)
                        }
                    }

                    if !sourceReferences.isEmpty {
                        ReferenceLinksSection(
                            title: "Sources",
                            buttonTitle: "Reference Link",
                            references: sourceReferences
                        )
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                }
                .coordinateSpace(name: "signalScroll")
                .onPreferenceChange(ViewOffsetKey.self) { y in
                    scrollY = y
                }
            }
        }
        // No explicit navigation title; header content provides the context
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// MARK: - Top Shade
private struct TopShade: View {
    let accentColor: Color
    // 0...1 where 1 is strong shade (top), 0 is faint
    let progress: CGFloat

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        // Base accent gradient (Apple-style header shade)
        // Bright at the very top, then gently desaturates and fades out
        let base = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: accentColor.opacity(0.95), location: 0.0),
                .init(color: accentColor.opacity(scheme == .dark ? 0.78 : 0.72), location: 0.28),
                .init(color: accentColor.opacity(scheme == .dark ? 0.52 : 0.45), location: 0.55),
                .init(color: accentColor.opacity(0.0), location: 0.82)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )

        // A soft darkening ramp that creates the clean fade-into-background look
        let darkRamp = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: Color.black.opacity(scheme == .dark ? 0.10 : 0.04), location: 0.0),
                .init(color: Color.black.opacity(scheme == .dark ? 0.20 : 0.08), location: 0.35),
                .init(color: Color.black.opacity(scheme == .dark ? 0.55 : 0.16), location: 0.70),
                .init(color: Color.black.opacity(0.0), location: 0.98)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )

        ZStack {
            base
            darkRamp
        }
        .opacity(0.95 * Double(progress))
        .frame(maxWidth: .infinity, maxHeight: 420)
        .transition(.opacity)
    }
}

// MARK: - Scroll offset key
private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private extension SignalDetailView {
    var shadeProgress: CGFloat {
        // scrollY is near 0 at rest; becomes negative when scrolled up
        let p = min(max(1.0 - (-scrollY / 240.0), 0.0), 1.0)
        return p
    }

    var colorForScheme: Color {
        scheme == .dark ? .white : .black
    }

    var sourceReferences: [ReferenceLink] {
        sources.compactMap { source in
            guard let url = URL(string: source) else { return nil }
            let host = url.host?.replacingOccurrences(of: "www.", with: "")
            let title = host?.isEmpty == false ? host! : source
            return ReferenceLink(title: title, url: url)
        }
    }
}

#Preview {
    NavigationStack {
        SignalDetailView(
            title: "Breathing discomfort",
            subtitle: "Breathing feels heavier or less comfortable than usual.",
            sections: [
                .init(title: "What this signal is?", body: "Breathing discomfort means your breathing feels heavier or less comfortable than usual. You may notice shortness of breath, a tight feeling in your chest, or that it takes more effort to breathe during simple activities."),
                .init(title: "Why it can happen on polluted days", body: "On polluted days, tiny particles like PM2.5 and gases such as ozone can irritate the airways and reduce airflow, which may lead to discomfort even while resting."),
                .init(title: "What you can do right now?", bullets: [
                    "Pause outdoor activity and rest until your breathing feels easier",
                    "Move to an indoor space and keep windows closed if outside air is poor",
                    "Focus on slow, calm breathing to help your body relax"
                ]),
                .init(title: "When to get extra help", body: "If breathing feels very hard, painful, or remains uncomfortable even after resting in clean air, seek medical advice.")
            ],
            accentColor: .red,
            iconName: "lungs.fill",
            sources: [
                "https://www.airnow.gov/air-quality-and-health/your-health/",
                "https://www.cdc.gov/air-quality/pollutants/index.html"
            ]
        )
    }
    .preferredColorScheme(.dark)
}
