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
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: type.systemImageName)
                    .font(.footnote)
                    .foregroundStyle(iconColor ?? .primary)
                    .frame(minWidth: 0, alignment: .leading)

                Text(status)
                    .font(.caption2)
                    .foregroundStyle(statusColor ?? .secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Spacer(minLength: 0)
            }

            Text(type.title)
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(titleColor ?? .primary)
                .lineLimit(1)
                .truncationMode(.tail)
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
