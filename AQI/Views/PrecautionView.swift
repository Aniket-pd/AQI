//
//  PrecautionView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

struct PrecautionView: View {
    @StateObject private var viewModel = PrecautionViewModel()
    @State private var selectedGuide: AQIGuideNav?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.ranges) { range in
                        PrecautionCardView(range: range) {
                            selectedGuide = AQIGuideNav(kind: AQIGuideKind.from(range: range), accentColor: range.accentColor)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Precaution")
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedGuide) { nav in
                switch nav.kind {
                case .good:
                    StepGuide_0_50_View(accentColor: nav.accentColor)
                case .moderate:
                    StepGuide_51_100_View(accentColor: nav.accentColor)
                case .usg:
                    StepGuide_101_150_View(accentColor: nav.accentColor)
                case .unhealthy:
                    StepGuide_151_200_View(accentColor: nav.accentColor)
                case .veryUnhealthy:
                    StepGuide_201_300_View(accentColor: nav.accentColor)
                case .hazardous:
                    StepGuide_301_Plus_View(accentColor: nav.accentColor)
                }
            }
        }
    }
}

#Preview {
    PrecautionView()
        .preferredColorScheme(.dark)
}

// MARK: - Routing model for specific AQI guide screens
struct AQIGuideNav: Identifiable, Hashable {
    let id = UUID()
    let kind: AQIGuideKind
    let accentColor: Color
}

enum AQIGuideKind: Hashable {
    case good
    case moderate
    case usg
    case unhealthy
    case veryUnhealthy
    case hazardous

    static func from(range: AQIRange) -> AQIGuideKind {
        switch range.aqiRange {
        case "AQI 0–50": return .good
        case "AQI 51–100": return .moderate
        case "AQI 101–150": return .usg
        case "AQI 151–200": return .unhealthy
        case "AQI 201–300": return .veryUnhealthy
        case "AQI 301+": return .hazardous
        default: return .moderate
        }
    }
}
