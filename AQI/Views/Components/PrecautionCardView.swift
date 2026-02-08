//
//  PrecautionCardView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct PrecautionCardView: View {
    let range: AQIRange
    var onStartGuide: (() -> Void)? = nil
    @State private var particleTrigger = UUID()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var isLightMode: Bool { colorScheme == .light }

    private var gradientColors: [Color] {
        if isLightMode {
            // Higher contrast in Light Mode so the card pops on white backgrounds
            return [
                range.accentColor.opacity(1.0),
                range.accentColor.opacity(0.80)
            ]
        } else {
            // Keep existing Dark Mode look
            return [
                range.accentColor.opacity(0.95),
                range.accentColor.opacity(0.55)
            ]
        }
    }

    private var borderOpacity: Double { isLightMode ? 0.18 : 0.12 }
    private var buttonBackgroundOpacity: Double { isLightMode ? 0.26 : 0.22 }
    private var blob1Opacity: Double { isLightMode ? 0.12 : 0.15 }
    private var blob2Opacity: Double { isLightMode ? 0.06 : 0.08 }

    var body: some View {
        ZStack {
            // Vibrant, softly blended gradient inspired by the mock
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Soft highlight blobs to add depth
            Circle()
                .fill(Color.white.opacity(blob1Opacity))
                .frame(width: 140, height: 140)
                .blur(radius: 20)
                .offset(x: 60, y: 58)

            Circle()
                .fill(Color.white.opacity(blob2Opacity))
                .frame(width: 120, height: 120)
                .blur(radius: 18)
                .offset(x: -50, y: -60)

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(range.title)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))

                Text(range.aqiRange)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(range.detail)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)

                Spacer(minLength: 0)

                HStack {
                    Spacer()
                    Button(range.buttonTitle) { onStartGuide?() }
                        .font(.headline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(.white.opacity(buttonBackgroundOpacity))
                        .clipShape(Capsule())
                }
            }
            .padding(20)

            // SwiftUI particle field (battery-friendly, clipped, subtle)
            SwiftUIParticleField(
                mood: AQIParticleMood.mood(for: range),
                cornerRadius: 20,
                trigger: particleTrigger
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.white.opacity(borderOpacity), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(isLightMode ? 0.14 : 0.0), radius: isLightMode ? 14 : 0, x: 0, y: isLightMode ? 8 : 0)
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            // Tapping anywhere on the card except the Guide button triggers a short burst
            // The inner Button consumes its own taps, so this gesture won't fire for it.
            particleTrigger = UUID()
        }
        .onAppear {
            // Play once by default when the view first appears.
            DispatchQueue.main.async {
                particleTrigger = UUID()
            }
        }
    }
}

#Preview {
    PrecautionCardView(
        range: AQIRange(
            title: "Moderate",
            aqiRange: "AQI 51–100",
            summary: "Be Aware",
            detail: "Air quality is acceptable.",
            iconName: "aqi.medium",
            accentColor: .orange,
            buttonTitle: "Guide"
        )
    )
    .padding()
    .preferredColorScheme(.dark)
}
