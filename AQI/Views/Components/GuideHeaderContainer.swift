//
//  GuideHeaderContainer.swift
//  AQI
//
//  Reusable header card shown below the animated background.
//  Contains: label, large title, AQI spectrum bar with marker, and subtitle.
//

import SwiftUI

struct GuideHeaderContainer: View {
    let range: AQIRange
    let guideSubtitle: String
    let aqiCategory: AQICategory

    private let hPadding: CGFloat = 16
    private let vPadding: CGFloat = 14

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 1) Small uppercase label with subtle icon
            HStack(spacing: 6) {
                Image(systemName: "circle.grid.3x3")
                    .imageScale(.small)
                    .foregroundStyle(.secondary)
                Text("AIR QUALITY")
                    .font(.caption.weight(.semibold))
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
            }

            // 2) Large bold category title
            Text(range.title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)

            // 3) Full-width AQI spectrum bar with rounded ends and marker
            AQISpectrumBar(category: aqiCategory)

            // 4) Guide subtitle
            if !guideSubtitle.isEmpty {
                Text(guideSubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            // 5) Solutions row (matches SolutionItem preview layout)
            let statuses = SolutionsAdvisor.statuses(for: aqiCategory)
            HStack(spacing: 8) {
                AirPurifierSolutionItem(status: statuses[.airPurifier] ?? "")
                    .frame(maxWidth: .infinity)
                N95MaskSolutionItem(status: statuses[.n95Mask] ?? "")
                    .frame(maxWidth: .infinity)
                StayIndoorSolutionItem(status: statuses[.stayIndoor] ?? "")
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, hPadding)
        .padding(.vertical, vPadding)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

// MARK: - Spectrum Bar
private struct AQISpectrumBar: View {
    let category: AQICategory

    private var colors: [Color] {
        [
            Color(hue: 0.33, saturation: 0.6, brightness: 0.85), // softer green
            Color(hue: 0.16, saturation: 0.7, brightness: 0.9),  // softer yellow
            Color(hue: 0.08, saturation: 0.75, brightness: 0.9), // softer orange
            Color(hue: 0.00, saturation: 0.7, brightness: 0.85),  // softer red
            Color(hue: 0.82, saturation: 0.4, brightness: 0.75),  // softer purple
            Color(red: 0.35, green: 0.05, blue: 0.15)             // muted maroon
        ]
    }

    private var position: CGFloat {
        // Position along 0...1 for the marker, tuned for visual balance
        switch category {
        case .good_0_50: return 0.08
        case .moderate_51_100: return 0.28
        case .usg_101_150: return 0.44
        case .unhealthy_151_200: return 0.64
        case .veryUnhealthy_201_300: return 0.82
        case .hazardous_300_plus: return 0.96
        }
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let markerDiameter: CGFloat = min(10, max(6, height * 1.6))
            let x = max(markerDiameter/2, min(width - markerDiameter/2, width * position))

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))

                // Marker
                Circle()
                    .fill(Color.white)
                    .frame(width: markerDiameter, height: markerDiameter)
                    .overlay(Circle().stroke(Color.black.opacity(0.15), lineWidth: 0.5))
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 1)
                    .position(x: x, y: height/2)
                    .accessibilityLabel("AQI position indicator")
            }
        }
        .frame(height: 3) // extra thin spectrum line
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: 16) {
        GuideHeaderContainer(
            range: AQIRange(
                title: "Moderately Polluted",
                aqiRange: "AQI 51–100",
                summary: "",
                detail: "",
                iconName: "",
                accentColor: .orange,
                buttonTitle: ""
            ),
            guideSubtitle: "Air quality is acceptable; some pollutants may be a concern for a very small number of people.",
            aqiCategory: .moderate_51_100
        )
        .padding()
    }
    .background(Color(.systemGroupedBackground))
    .preferredColorScheme(.dark)
}
