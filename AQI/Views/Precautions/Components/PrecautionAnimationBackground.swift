//
//  PrecautionAnimationBackground.swift
//  AQI
//
//  Renders only the animated background (gradient + particles).
//  No text overlays are included here.
//

import SwiftUI

struct PrecautionAnimationBackground: View {
    let range: AQIRange
    var height: CGFloat = 180
    // Optional override for how long particles play; default uses the field default
    var playDuration: TimeInterval? = nil

    @State private var particleTrigger = UUID()

    var body: some View {
        ZStack {
            // Gradient background (same palette as PrecautionCard)
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

            // Particle animation layer
            SwiftUIParticleField(
                mood: AQIParticleMood.mood(for: range),
                cornerRadius: 0,
                trigger: particleTrigger,
                activeDuration: playDuration ?? 2.2,
                fadeOutWindow: 0.9
            )

            // Intentionally text-free: all labels/titles are handled by parent views
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .onTapGesture {
            // Retrigger animation on tap
            particleTrigger = UUID()
        }
        .onAppear {
            // Play once by default when the view is opened
            DispatchQueue.main.async { particleTrigger = UUID() }
        }
    }
}

#Preview {
    let range = AQIRange(
        category: .unhealthy_151_200,
        title: "Unhealthy",
        summary: "",
        detail: "",
        iconName: "",
        accentColor: .red,
        buttonTitle: ""
    )
    return PrecautionAnimationBackground(range: range)
        .padding()
        .preferredColorScheme(.dark)
}
