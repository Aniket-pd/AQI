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
                .init(title: "What you can do right now?", body: "Pause heavy activity and move to a cleaner indoor space with windows closed. Breathe slowly and calmly, and consider using an air purifier if available."),
                .init(title: "When to get extra help", body: "If breathing feels very hard, painful, or remains uncomfortable even after resting in clean air, seek medical advice.")
            ],
            accentColor: .red,
            iconName: "lungs.fill"
        )
    }
    .preferredColorScheme(.dark)
}
