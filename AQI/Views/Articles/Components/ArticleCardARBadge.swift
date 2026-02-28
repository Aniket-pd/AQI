//
//  ArticleCardARBadge.swift
//  AQI
//
//  A subtle system-style tag shown on article cards that include an AR experience.
//

import SwiftUI

struct ArticleCardARBadge: View {
    var body: some View {
        Label {
            Text("AR View")
        } icon: {
            Image(systemName: "arkit")
        }
        .font(.footnote)
        .labelStyle(.titleAndIcon)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .accessibilityHidden(false)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ArticleCardARBadge()
        .padding()
        .background(Color(.secondarySystemBackground))
}
