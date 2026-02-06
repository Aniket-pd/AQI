//
//  SolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

/// Minimal horizontal card with a large symbol and two-line text.
struct SolutionItem: View {
    let type: SolutionType
    let status: String
    var iconColor: Color? = nil
    var titleColor: Color? = nil
    var statusColor: Color? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.systemImageName)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(iconColor ?? .secondary)
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 2) {
                Text(type.title)
                    .font(.headline)
                    .foregroundStyle(titleColor ?? .primary)
                    .lineLimit(1)
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(statusColor ?? .secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            // System-adaptive material keeps it clean on light/dark.
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.regularMaterial)
        )
        .overlay(
            // Subtle separator to keep definition across backgrounds.
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(type.title), \(status)"))
    }
}

#if DEBUG
// Optional alternate name as requested.
typealias SaltItem = SolutionItem
#endif

#Preview {
    VStack(spacing: 16) {
        SolutionItem(type: .airPurifier, status: "Turn On")
        SolutionItem(type: .n95Mask, status: "Recommended")
        SolutionItem(type: .stayIndoor, status: "Must")
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
