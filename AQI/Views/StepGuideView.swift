//
//  StepGuideView.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI
import UIKit

struct StepGuideView: View {
    let guideSubtitle: String
    let steps: [GuideStep]
    let accentColor: Color
    let aqiCategory: AQICategory

    private let expandAnimation: Animation = .spring(response: 0.35, dampingFraction: 0.88, blendDuration: 0.2)
    private let advanceAnimation: Animation = .spring(response: 0.38, dampingFraction: 0.9, blendDuration: 0.2)

    @State private var currentIndex: Int = 0
    @State private var expandedIndex: Int? = nil
    @State private var isActive: Bool = false

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                    LazyVStack(alignment: .leading, spacing: 20) {
                    // Top precaution card with particles (plays once on appear, retrigger on tap)
                    precautionCard

                    // Solutions section header + grid
                    SectionHeaderView(title: "SUGGESTED ACTIONS")
                    solutionsGrid

                    // Optional short context beneath solutions
                    if !guideSubtitle.isEmpty {
                        Text(guideSubtitle)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    // Steps section (rest content)
                    VStack(spacing: 12) {
                        ForEach(steps.indices, id: \.self) { idx in
                            StepCardRow(
                                index: idx,
                                step: steps[idx],
                                accentColor: accentColor,
                                isExpanded: Binding(
                                    get: { expandedIndex == idx },
                                    set: { newValue in
                                        withAnimation(expandAnimation) {
                                            expandedIndex = newValue ? idx : nil
                                            if newValue { currentIndex = idx }
                                        }
                                        if newValue { impact(.light) }
                                    }
                                ),
                                onTap: {
                                    withAnimation(expandAnimation) {
                                        if expandedIndex == idx {
                                            expandedIndex = nil
                                        } else {
                                            expandedIndex = idx
                                            currentIndex = idx
                                        }
                                    }
                                    impact(.light)
                                }
                            )
                            .id(idx)
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                    }
                    .animation(expandAnimation, value: expandedIndex)
                }
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .coordinateSpace(name: "scroll")
            // Allow content (header) to extend behind the notch/nav bar
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.large)
            .safeAreaInset(edge: .bottom) {
                // Bottom Next button
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        Button(action: nextStep) {
                            Text(currentIndex < steps.count - 1 ? "Next Step" : "Finish")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(accentColor)
                        .controlSize(.large)
                        .buttonBorderShape(.capsule)
                        .disabled(steps.isEmpty)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                // Fresh open: start collapsed
                currentIndex = 0
                expandedIndex = nil
                isActive = true
            }
            .onDisappear { isActive = false }
            .onChange(of: expandedIndex) { _, newValue in
                guard let idx = newValue else { return }
                DispatchQueue.main.async {
                    withAnimation(expandAnimation) {
                        proxy.scrollTo(idx, anchor: .center)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Components

    private var precautionCard: some View {
        GeometryReader { proxy in
            let topInset = topSafeArea
            let minHeight: CGFloat = 200 + topInset
            let y = proxy.frame(in: .named("scroll")).minY
            let stretch = max(0, y)
            let dynamicHeight = minHeight + stretch

            PrecautionAnimationBackground(
                range: rangeInfo(for: aqiCategory),
                isActive: $isActive,
                height: dynamicHeight
            )
            .frame(maxWidth: .infinity)
            .frame(height: dynamicHeight)
            .offset(y: -(topInset + stretch))
            .padding(.horizontal, -16) // edge-to-edge despite outer padding
            .ignoresSafeArea(edges: .top)
        }
        .frame(height: 200 + topSafeArea) // occupy space including notch
    }

    // Alias for naming consistency in code comments
    private var stretchyHeader: some View { precautionCard }

    private var solutionsGrid: some View {
        let statuses = SolutionsAdvisor.statuses(for: aqiCategory)
        let items: [(AnyView, String)] = [
            (AnyView(AirPurifierSolutionItem(status: statuses[.airPurifier] ?? "")), "air"),
            (AnyView(N95MaskSolutionItem(status: statuses[.n95Mask] ?? "")), "mask"),
            (AnyView(StayIndoorSolutionItem(status: statuses[.stayIndoor] ?? "")), "indoor")
        ]

        let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ]

        return LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, pair in
                pair.0
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            }
        }
    }

    private func rangeInfo(for category: AQICategory) -> AQIRange {
        switch category {
        case .good_0_50:
            return AQIRange(
                title: "Good",
                aqiRange: "AQI 0–50",
                summary: "Enjoy Outside",
                detail: "Air quality is satisfactory and air pollution poses little or no risk.",
                iconName: "aqi.low",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .moderate_51_100:
            return AQIRange(
                title: "Moderate",
                aqiRange: "AQI 51–100",
                summary: "Be Aware",
                detail: "Air quality is acceptable; some pollutants may be a concern for a very small number of people.",
                iconName: "aqi.medium",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .usg_101_150:
            return AQIRange(
                title: "Unhealthy for Sensitive Groups",
                aqiRange: "AQI 101–150",
                summary: "Caution",
                detail: "Members of sensitive groups may experience health effects. The general public is less likely to be affected.",
                iconName: "exclamationmark.triangle",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .unhealthy_151_200:
            return AQIRange(
                title: "Unhealthy",
                aqiRange: "AQI 151–200",
                summary: "Reduce Outdoor Activity",
                detail: "Everyone may begin to experience adverse health effects; sensitive groups may experience more serious effects.",
                iconName: "exclamationmark.octagon",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .veryUnhealthy_201_300:
            return AQIRange(
                title: "Very Unhealthy",
                aqiRange: "AQI 201–300",
                summary: "Health Alert",
                detail: "Health warnings of emergency conditions. The entire population is more likely to be affected.",
                iconName: "xmark.octagon",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .hazardous_300_plus:
            return AQIRange(
                title: "Hazardous",
                aqiRange: "AQI 300+",
                summary: "Avoid Exposure",
                detail: "Health alert: everyone may experience more serious health effects.",
                iconName: "aqi.high",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        }
    }

    private func nextStep() {
        guard !steps.isEmpty else { return }
        impact(.medium)

        // If nothing is expanded, start from the first step.
        if expandedIndex == nil {
            withAnimation(advanceAnimation) {
                currentIndex = 0
                expandedIndex = 0
            }
            return
        }

        withAnimation(advanceAnimation) {
            if currentIndex < steps.count - 1 {
                // Advance to next step
                currentIndex += 1
                expandedIndex = currentIndex
            } else {
                // Last step: collapse all
                expandedIndex = nil
            }
        }
    }

    private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
}

// MARK: - Safe area helper
private var topSafeArea: CGFloat {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .keyWindow?.safeAreaInsets.top ?? 0
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}

#Preview {
    let steps = [
        GuideStep(title: "Call Emergency Services", content: "Dial your local emergency number (e.g., 112/911) and provide your location and symptoms."),
        GuideStep(title: "Assess Safety", content: "Ensure the area is safe and avoid exposure to harmful air. Move indoors if possible."),
        GuideStep(title: "Provide Care", content: "Follow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional help.")
    ]
    return NavigationStack {
        StepGuideView(
            guideSubtitle: "Quick steps to follow during a suspected heart attack.",
            steps: steps,
            accentColor: .red,
            aqiCategory: .unhealthy_151_200
        )
    }
    .preferredColorScheme(.dark)
}
