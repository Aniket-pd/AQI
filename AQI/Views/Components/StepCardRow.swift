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
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Capsule())

                Text(step.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
            }
            .contentShape(Rectangle())
            .onTapGesture { onTap() }

            if isExpanded {
                Divider().background(Color.white.opacity(0.1))
                Text(step.content)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 0.13, green: 0.13, blue: 0.17))
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
        .background(Color(red: 0.08, green: 0.08, blue: 0.11))
}

