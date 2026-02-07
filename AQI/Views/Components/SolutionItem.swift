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
                .font(.footnote)
                .foregroundStyle(iconColor ?? .primary)
                .frame(minWidth: 0, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(type.title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(titleColor ?? .primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(status)
                    .font(.caption2)
                    .foregroundStyle(statusColor ?? .secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
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
    HStack(spacing: 8) {
        SolutionItem(type: .airPurifier, status: "Turn On")
            .frame(maxWidth: .infinity)
        SolutionItem(type: .n95Mask, status: "Recommended")
            .frame(maxWidth: .infinity)
        SolutionItem(type: .stayIndoor, status: "Must")
            .frame(maxWidth: .infinity)
    }
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
