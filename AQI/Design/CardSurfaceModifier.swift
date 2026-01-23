//
//  CardSurfaceModifier.swift
//  AQI
//
//  Created by Assistant on 24/1/26.
//

import SwiftUI

struct CardBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    let cornerRadius: CGFloat
    let showShadow: Bool

    func body(content: Content) -> some View {
        let fillColor: Color = colorScheme == .light ? Color(.systemBackground) : Color(.secondarySystemBackground)

        return content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fillColor)
            )
            // Light mode: soft dual elevation shadows like system cards
            .shadow(
                color: Color.black.opacity(colorScheme == .light && showShadow ? 0.08 : 0),
                radius: 20, x: 0, y: 10
            )
            .shadow(
                color: Color.black.opacity(colorScheme == .light && showShadow ? 0.03 : 0),
                radius: 3, x: 0, y: 1
            )
            // Dark mode: no shadow; add subtle hairline for edge definition
            .overlay(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.06), lineWidth: 1)
                    }
                }
            )
    }
}

extension View {
    func cardBackground(cornerRadius: CGFloat, showShadow: Bool = true) -> some View {
        modifier(CardBackground(cornerRadius: cornerRadius, showShadow: showShadow))
    }
}
