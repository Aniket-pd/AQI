//
//  StepCardRow.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import SwiftUI

struct StepCardRow: View {
    let index: Int
    let step: GuideStep
    let accentColor: Color
    @Binding var isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text(step.title)
                    .font(.headline)
                    .foregroundStyle(isExpanded ? .white : .primary)

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(isExpanded ? .white : .secondary)
                    .opacity(isExpanded ? 0.85 : 1.0)
                    .font(.system(size: 14, weight: .semibold))
            }
            .contentShape(Rectangle())
            .onTapGesture { onTap() }

            if isExpanded {
                Divider()
                Text(step.content)
                    .font(.subheadline)
                    .foregroundStyle(isExpanded ? .white : .primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            ZStack {
                if isExpanded {
                    // Match PrecautionCard surface material & accent
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.95),
                            accentColor.opacity(0.55)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 120, height: 120)
                        .blur(radius: 18)
                        .offset(x: 60, y: 48)
                    Circle()
                        .fill(Color.white.opacity(0.06))
                        .frame(width: 100, height: 100)
                        .blur(radius: 16)
                        .offset(x: -50, y: -50)
                } else {
                    Color(.secondarySystemGroupedBackground)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(isExpanded ? Color.white.opacity(0.12) : Color.clear, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

#Preview {
    @State var expanded = true
    let step = GuideStep(title: "Call Emergency Services", content: "Dial 112/911 immediately and provide location.")
    return StepCardRow(index: 0, step: step, accentColor: .green, isExpanded: $expanded, onTap: {})
        .preferredColorScheme(.dark)
        .padding()
        .background(Color(.systemGroupedBackground))
}
