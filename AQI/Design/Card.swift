//
//  Card.swift
//  AQI
//
//  A reusable card container that applies
//  system-aligned surfaces across light/dark modes.
//

import SwiftUI

struct CardContainer<Content: View>: View {
    let cornerRadius: CGFloat
    let padding: CGFloat
    let showShadow: Bool
    @ViewBuilder var content: Content

    init(cornerRadius: CGFloat = 20, padding: CGFloat = 16, showShadow: Bool = true, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.showShadow = showShadow
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .cardBackground(cornerRadius: cornerRadius, showShadow: showShadow)
    }
}

