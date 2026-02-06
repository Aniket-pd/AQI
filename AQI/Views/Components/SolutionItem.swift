//
//  SolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

/// Minimal flat row with a symbol and two-line text, system colors only.
struct SolutionItem: View {
    let type: SolutionType
    let status: String
    var iconColor: Color? = nil
    var titleColor: Color? = nil
    var statusColor: Color? = nil

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: type.systemImageName)
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(iconColor ?? .primary)
                .frame(width: 30, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(type.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(titleColor ?? .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .allowsTightening(true)
                    .layoutPriority(1)
                Text(status)
                    .font(.subheadline)
                    .foregroundStyle(statusColor ?? .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .allowsTightening(true)
                    .layoutPriority(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
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
