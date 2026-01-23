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
                Text("Step \(index + 1)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.tertiarySystemFill))
                    .clipShape(Capsule())

                Text(step.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.tertiary)
                    .font(.system(size: 14, weight: .semibold))
            }
            .contentShape(Rectangle())
            .onTapGesture { onTap() }

            if isExpanded {
                Divider()
                Text(step.content)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(isExpanded ? accentColor.opacity(0.5) : Color.clear, lineWidth: 1)
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
