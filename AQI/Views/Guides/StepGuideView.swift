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
    // Consistent visual gap between animated header and header card
    private let headerGap: CGFloat = 12

    @State private var currentIndex: Int = 0
    @State private var expandedIndex: Int? = nil
    // Reuse prepared haptic generators to avoid first-tap latency
    @State private var hapticLight = UIImpactFeedbackGenerator(style: .light)
    @State private var hapticMedium = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    // Top precaution card (animated background)
                    precautionCard

                    // Header + steps in one stack so spacing stays even
                    VStack(spacing: 12) {
                        GuideHeaderContainer(
                            range: rangeInfo(for: aqiCategory),
                            guideSubtitle: guideSubtitle,
                            aqiCategory: aqiCategory
                        )

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
                    // Add a fixed gap so spacing to the animated header looks
                    // consistent across devices and never overlaps.
                    .padding(.top, headerGap)
                }
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .coordinateSpace(name: "scroll")
            // Allow content (header) to extend behind the notch/nav bar
            .ignoresSafeArea(edges: .top)
            // No navigation bar title; header shows the context
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
                // Pre-warm haptics once to avoid first-use stall
                hapticLight.prepare()
                hapticMedium.prepare()
            }
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

    // removed old guideSubtitleContainer; replaced by GuideHeaderContainer component

    private var precautionCard: some View {
        GeometryReader { proxy in
            let topInset = topSafeArea
            let minHeight: CGFloat = 270 + topInset
            let y = proxy.frame(in: .named("scroll")).minY
            let stretch = max(0, y)
            let dynamicHeight = minHeight + stretch
            let range = rangeInfo(for: aqiCategory)

            ZStack(alignment: .bottomLeading) {
                // Edge-to-edge animated background
                PrecautionAnimationBackground(
                    range: range,
                    height: dynamicHeight,
                    playDuration: 10
                )

                // Large navigation-style title at bottom-left
                Text(range.aqiRange)
                    .font(.system(size: 34, weight: .heavy, design: .default))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .padding(.leading, 16)
                    .padding(.bottom, 18)
            }
            .frame(maxWidth: .infinity)
            .frame(height: dynamicHeight)
            .offset(y: -(topInset + stretch))
            .padding(.horizontal, -16) // edge-to-edge despite outer padding
            .ignoresSafeArea(edges: .top)
        }
        // Keep the header container's layout height constant so the next content
        // starts exactly where the animated background visually ends. This removes
        // safe-area dependent gaps and makes the overlap consistent.
        .frame(height: 270)
    }

    // Alias for naming consistency in code comments
    private var stretchyHeader: some View { precautionCard }

    // Solutions row is rendered inside GuideHeaderContainer

    private func rangeInfo(for category: AQICategory) -> AQIRange {
        switch category {
        case .good_0_50:
            return AQIRange(
                category: .good_0_50,
                title: "Good",
                summary: "Enjoy Outside",
                detail: "Air quality is satisfactory and air pollution poses little or no risk.",
                iconName: "aqi.low",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .moderate_51_100:
            return AQIRange(
                category: .moderate_51_100,
                title: "Moderate",
                summary: "Be Aware",
                detail: "Air quality is acceptable; some pollutants may be a concern for a very small number of people.",
                iconName: "aqi.medium",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .usg_101_150:
            return AQIRange(
                category: .usg_101_150,
                title: "Unhealthy for Sensitive Groups",
                summary: "Caution",
                detail: "Members of sensitive groups may experience health effects. The general public is less likely to be affected.",
                iconName: "exclamationmark.triangle",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .unhealthy_151_200:
            return AQIRange(
                category: .unhealthy_151_200,
                title: "Unhealthy",
                summary: "Reduce Outdoor Activity",
                detail: "Everyone may begin to experience adverse health effects; sensitive groups may experience more serious effects.",
                iconName: "exclamationmark.octagon",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .veryUnhealthy_201_300:
            return AQIRange(
                category: .veryUnhealthy_201_300,
                title: "Very Unhealthy",
                summary: "Health Alert",
                detail: "Health warnings of emergency conditions. The entire population is more likely to be affected.",
                iconName: "xmark.octagon",
                accentColor: accentColor,
                buttonTitle: "Guide"
            )
        case .hazardous_300_plus:
            return AQIRange(
                category: .hazardous_300_plus,
                title: "Hazardous",
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
        switch style {
        case .light:
            hapticLight.impactOccurred()
            // prepare for the next usage to keep latency low
            hapticLight.prepare()
        case .medium:
            hapticMedium.impactOccurred()
            hapticMedium.prepare()
        case .heavy:
            // Create on demand if heavy is ever requested; keep behavior safe
            let heavy = UIImpactFeedbackGenerator(style: .heavy)
            heavy.prepare()
            heavy.impactOccurred()
        @unknown default:
            hapticLight.impactOccurred()
            hapticLight.prepare()
        }
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
            guideSubtitle: "Quick steps to follow during a suspected heart attacQuick steps to follow during a suspected heart attacQuick steps to follow during a suspected heart attack.",
            steps: steps,
            accentColor: .red,
            aqiCategory: .unhealthy_151_200
        )
    }
    .preferredColorScheme(.dark)
}
