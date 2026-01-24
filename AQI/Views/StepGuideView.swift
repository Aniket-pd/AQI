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
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                // Subtitle / context
                Text(guideSubtitle)
                    .font(.body)
                    .foregroundStyle(.secondary)
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
