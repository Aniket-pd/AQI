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
                let columns = [GridItem(.flexible(), spacing: 0)]
                LazyVGrid(columns: columns, spacing: 18) {
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
        switch range.category {
        case .good_0_50: return .good
        case .moderate_51_100: return .moderate
        case .usg_101_150: return .usg
        case .unhealthy_151_200: return .unhealthy
        case .veryUnhealthy_201_300: return .veryUnhealthy
        case .hazardous_300_plus: return .hazardous
        }
    }
}
