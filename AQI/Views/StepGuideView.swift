//
//  StepGuideView.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepGuideView: View {
    let guideTitle: String
    let guideSubtitle: String
    let steps: [GuideStep]
    let accentColor: Color

    @State private var currentIndex: Int = 0
    @State private var expandedIndex: Int? = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Top section
                    VStack(alignment: .leading, spacing: 10) {
                        Text(guideTitle)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                        Text(guideSubtitle)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.top, 8)

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
                                        expandedIndex = newValue ? idx : nil
                                        if newValue { currentIndex = idx }
                                    }
                                ),
                                onTap: {
                                    withAnimation {
                                        if expandedIndex == idx {
                                            expandedIndex = nil
                                        } else {
                                            expandedIndex = idx
                                            currentIndex = idx
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color(red: 0.08, green: 0.08, blue: 0.11).ignoresSafeArea())
        .navigationTitle("Guide")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            // Bottom Next button
            VStack(spacing: 10) {
                Button(action: nextStep) {
                    HStack {
                        Text(currentIndex < steps.count - 1 ? "Next Step" : "Finish")
                        Spacer()
                        Image(systemName: currentIndex < steps.count - 1 ? "arrow.right" : "checkmark")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .disabled(steps.isEmpty)
                .opacity(steps.isEmpty ? 0.6 : 1)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .background(.ultraThinMaterial.opacity(0.15))
        }
        .onAppear {
            // Ensure initial state: only first step expanded
            if !steps.isEmpty {
                currentIndex = 0
                expandedIndex = 0
            } else {
                expandedIndex = nil
            }
        }
    }

    private func nextStep() {
        guard !steps.isEmpty else { return }
        withAnimation {
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
}

#Preview {
    let steps = [
        GuideStep(title: "Call Emergency Services", content: "Dial your local emergency number (e.g., 112/911) and provide your location and symptoms."),
        GuideStep(title: "Assess Safety", content: "Ensure the area is safe and avoid exposure to harmful air. Move indoors if possible."),
        GuideStep(title: "Provide Care", content: "Follow recommended actions while awaiting professional help.")
    ]
    return NavigationStack {
        StepGuideView(
            guideTitle: "Heart Attack",
            guideSubtitle: "Quick steps to follow during a suspected heart attack.",
            steps: steps,
            accentColor: .red
        )
    }
    .preferredColorScheme(.dark)
}

