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

    var body: some View {
        ZStack {
            // Vibrant, softly blended gradient inspired by the mock
            LinearGradient(
                colors: [
                    range.accentColor.opacity(0.95),
                    range.accentColor.opacity(0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Soft highlight blobs to add depth
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 140, height: 140)
                .blur(radius: 20)
                .offset(x: 60, y: 58)

            Circle()
                .fill(Color.white.opacity(0.08))
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
                        .background(.white.opacity(0.22))
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
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            // Tapping anywhere on the card except the Guide button triggers a short burst
            // The inner Button consumes its own taps, so this gesture won't fire for it.
            particleTrigger = UUID()
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
