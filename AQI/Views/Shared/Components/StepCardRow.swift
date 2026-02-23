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

    @Environment(\.colorScheme) private var colorScheme
    private var isLightMode: Bool { colorScheme == .light }

    private var expandedGradient: [Color] {
        if isLightMode {
            // Stronger gradient for better contrast on white backgrounds
            return [
                accentColor.opacity(1.0),
                accentColor.opacity(0.85)
            ]
        } else {
            // Keep existing dark mode look
            return [
                accentColor.opacity(0.95),
                accentColor.opacity(0.55)
            ]
        }
    }

    private var collapsedBackground: Color {
        // Slightly stronger surface in Light Mode for better separation
        isLightMode
        ? Color(.systemGray6)
        : Color(.secondarySystemGroupedBackground)
    }

    private var borderColor: Color {
        // In light mode, subtle dark border for card separation
        isLightMode
        ? Color.black.opacity(0.08)
        : Color.clear
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                // Leading symbol describing the section
                Image(systemName: iconForTitle(step.title))
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(isExpanded ? .white.opacity(0.9) : accentColor)
                    .font(.system(size: 16, weight: .semibold))

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
                    .transition(.opacity) // Avoid vertical move that could cross the divider line
            }
        }
        .padding(16)
        .background(
            ZStack {
                if isExpanded {
                    // Match PrecautionCard surface material & accent
                    LinearGradient(
                        colors: expandedGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                } else {
                    collapsedBackground
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) // Clip entire card container
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .clipped()
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(borderColor, lineWidth: isLightMode ? 1 : 0)
        )
        .shadow(
            color: Color.black.opacity(isLightMode ? 0.08 : 0.0),
            radius: isLightMode ? 10 : 0,
            x: 0,
            y: isLightMode ? 4 : 0
        )
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }

    // Map common guide titles to appropriate SF Symbols
    private func iconForTitle(_ title: String) -> String {
        let t = title.lowercased()

        // Exact matches used across guides
        if t == "understand your air" || t == "air overview" { return "wind" }
        if t == "what you should do" { return "checkmark.circle" }
        if t == "what to avoid" { return "nosign" }
        if t == "who needs extra care" { return "person.2" }
        if t == "indoor vs outdoor tips" { return "house" }
        if t == "body signals to watch" { return "waveform.path.ecg" }

        // Heuristic fallbacks for preview or new sections
        if t.contains("emergency") || t.contains("911") { return "phone" }
        if t.contains("safety") { return "exclamationmark.triangle" }
        if t.contains("care") { return "cross.case" }
        if t.contains("avoid") { return "nosign" }
        if t.contains("should do") || t.contains("do") { return "checkmark.circle" }
        if t.contains("indoor") || t.contains("outdoor") { return "house" }
        if t.contains("body") || t.contains("symptom") || t.contains("signals") { return "waveform.path.ecg" }
        if t.contains("air") { return "wind" }

        return "list.bullet"
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
