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
    @State private var selectedGuide: GuideRoute?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.ranges) { range in
                        PrecautionCardView(range: range) {
                            selectedGuide = GuideRoute.from(range: range)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Precaution")
            .background(Color(red: 0.08, green: 0.08, blue: 0.11))
            .navigationDestination(item: $selectedGuide) { route in
                StepGuideView(
                    guideTitle: route.title,
                    guideSubtitle: route.subtitle,
                    steps: route.steps,
                    accentColor: route.accentColor
                )
            }
        }
    }
}

#Preview {
    PrecautionView()
        .preferredColorScheme(.dark)
}

// MARK: - Routing model for navigationDestination(item:)
struct GuideRoute: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let steps: [GuideStep]
    let accentColor: Color

    // Conform to Hashable using the stable UUID id
    static func == (lhs: GuideRoute, rhs: GuideRoute) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func from(range: AQIRange) -> GuideRoute {
        // Example steps per AQI category. Replace with real content as needed.
        let commonSteps: [GuideStep] = [
            GuideStep(title: "Check Environment", content: "Assess outdoor air quality and avoid strenuous activity if levels are high."),
            GuideStep(title: "Protect Yourself", content: "Use a certified mask when outdoors and keep windows closed indoors."),
            GuideStep(title: "Monitor Health", content: "If you feel discomfort (coughing, breathing issues), limit exposure and seek advice.")
        ]

        let severeSteps: [GuideStep] = [
            GuideStep(title: "Stay Indoors", content: "Remain inside with doors/windows closed. Use air purifiers if available."),
            GuideStep(title: "Avoid Exposure", content: "Postpone outdoor activities. Wear a high‑filtration mask if you must go out."),
            GuideStep(title: "Seek Help if Needed", content: "If you experience severe symptoms, contact medical services immediately.")
        ]

        let steps: [GuideStep]
        switch range.title {
        case "Severe Air", "Very Poor Air":
            steps = severeSteps
        default:
            steps = commonSteps
        }

        return GuideRoute(
            title: range.title,
            subtitle: range.detail,
            steps: steps,
            accentColor: range.accentColor
        )
    }
}

