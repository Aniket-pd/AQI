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
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: iconName)
                            .foregroundColor(accentColor)
                            .font(.system(size: 24, weight: .semibold))
                            .frame(width: 44, height: 44)
                            .background(accentColor.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                                .font(.title2.bold())
                                .foregroundStyle(.primary)
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Sections
                    VStack(spacing: 14) {
                        ForEach(sections) { section in
                            SignalSectionRow(accentColor: accentColor, section: section)
                        }
                    }

                    if !sources.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sources")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(sources, id: \.self) { s in
                                    if let url = URL(string: s) {
                                        Link(destination: url) {
                                            HStack(spacing: 8) {
                                                Image(systemName: "link")
                                                    .font(.footnote)
                                                    .foregroundStyle(.secondary)
                                                Text(s)
                                                    .font(.footnote)
                                                    .foregroundStyle(.secondary)
                                                    .textSelection(.enabled)
                                            }
                                        }
                                    } else {
                                        HStack(spacing: 8) {
                                            Image(systemName: "link")
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                            Text(s)
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                                .textSelection(.enabled)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Signal")
        .navigationBarTitleDisplayMode(.inline)
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
