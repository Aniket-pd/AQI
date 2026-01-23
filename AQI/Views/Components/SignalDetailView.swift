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
    let points: [String]
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

                    // Points list
                    VStack(spacing: 12) {
                        ForEach(Array(points.enumerated()), id: \.offset) { _, text in
                            CardContainer(cornerRadius: 12, padding: 12, showShadow: false) {
                                HStack(alignment: .top, spacing: 10) {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 8, height: 8)
                                        .padding(.top, 7)
                                    Text(text)
                                        .font(.subheadline)
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
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
            subtitle: "Dummy guidance for breathing discomfort symptoms.",
            points: [
                "Limit heavy exertion and rest.",
                "Move to a clean indoor environment.",
                "Use a high‑filtration mask outdoors if needed."
            ],
            accentColor: .red,
            iconName: "lungs.fill"
        )
    }
    .preferredColorScheme(.dark)
}
