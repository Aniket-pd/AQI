//
//  SignalRowView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct SignalRowView: View {
    let item: SignalItem
    var showsChevron: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.iconName)
                .font(.system(size: 20))
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(item.tintColor)
                .frame(width: 32, height: 32)

            Text(item.title)
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
    }
}

#Preview {
    SignalRowView(
        item: SignalItem(
            title: "High PM2.5 Exposure",
            iconName: "drop.fill",
            tintColor: .blue,
            kind: .breathingDiscomfort
        )
    )
    .padding()
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
