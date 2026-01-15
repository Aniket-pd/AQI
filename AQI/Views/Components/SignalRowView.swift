//
//  SignalRowView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct SignalRowView: View {
    let item: SignalItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.iconName)
                .foregroundColor(item.tintColor)
                .frame(width: 28, height: 28)
                .background(item.tintColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text(item.title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
        }
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
    .background(Color.black)
    .preferredColorScheme(.dark)
}
