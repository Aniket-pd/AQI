//
//  StepGuideView.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI
import UIKit

struct StepGuideView: View {
    let guideTitle: String
    let guideSubtitle: String
    let steps: [GuideStep]
    let accentColor: Color
    let aqiCategory: AQICategory

    private let expandAnimation: Animation = .spring(response: 0.35, dampingFraction: 0.88, blendDuration: 0.2)
    private let advanceAnimation: Animation = .spring(response: 0.38, dampingFraction: 0.9, blendDuration: 0.2)

    @State private var currentIndex: Int = 0
    @State private var expandedIndex: Int? = nil

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    // Solutions row directly under the title
                    solutionsRow
                        .padding(.top, 6)

                    // Subtitle / context
                    Text(guideSubtitle)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    // Steps section
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
                .padding(.top, 4)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(guideTitle)
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
            }
            .onChange(of: expandedIndex) { _, newValue in
                guard let idx = newValue else { return }
                DispatchQueue.main.async {
                    withAnimation(expandAnimation) {
                        proxy.scrollTo(idx, anchor: .center)
                    }
                }
            }
        }
    }

    // MARK: - Components

    private var solutionsRow: some View {
        let statuses = SolutionsAdvisor.statuses(for: aqiCategory)
        return HStack(spacing: 12) {
            AirPurifierSolutionItem(status: statuses[.airPurifier] ?? "")
                .frame(maxWidth: .infinity)
            N95MaskSolutionItem(status: statuses[.n95Mask] ?? "")
                .frame(maxWidth: .infinity)
            StayIndoorSolutionItem(status: statuses[.stayIndoor] ?? "")
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 2)
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

#Preview {
    let steps = [
        GuideStep(title: "Call Emergency Services", content: "Dial your local emergency number (e.g., 112/911) and provide your location and symptoms."),
        GuideStep(title: "Assess Safety", content: "Ensure the area is safe and avoid exposure to harmful air. Move indoors if possible."),
        GuideStep(title: "Provide Care", content: "Follow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional helpFollow recommended actions while awaiting professional help.")
    ]
    return NavigationStack {
        StepGuideView(
            guideTitle: "Heart Attack",
            guideSubtitle: "Quick steps to follow during a suspected heart attack.",
            steps: steps,
            accentColor: .red,
            aqiCategory: .unhealthy_151_200
        )
    }
    .preferredColorScheme(.dark)
}
