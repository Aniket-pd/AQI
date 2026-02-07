//
//  PrecautionAnimationBackground.swift
//  AQI
//
//  Renders only the animated background (gradient + particles).
//  Optionally overlays the AQI range text when the parent view is active.
//

import SwiftUI

struct PrecautionAnimationBackground: View {
    let range: AQIRange
    @Binding var isActive: Bool
    var height: CGFloat = 180

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
                trigger: particleTrigger
            )

            // Only the AQI range text, shown only when StepGuideView is active
            if isActive {
                Text(range.aqiRange)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: 0, y: 1)
            }
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
    @State var active = true
    let range = AQIRange(
        title: "Unhealthy",
        aqiRange: "AQI 151–200",
        summary: "",
        detail: "",
        iconName: "",
        accentColor: .red,
        buttonTitle: ""
    )
    return PrecautionAnimationBackground(range: range, isActive: $active)
        .padding()
        .preferredColorScheme(.dark)
}
