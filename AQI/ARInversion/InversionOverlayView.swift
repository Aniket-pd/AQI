import SwiftUI

struct InversionOverlayView: View {
    @StateObject private var sim = InversionSimulation()
    @State private var playing = true

    var body: some View {
        ZStack {
            InversionARContainer(sim: sim)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                header
                Spacer()
                controls
            }
            .padding()
        }
        .onAppear { startTimer() }
        .onDisappear { playing = false }
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Temperature Inversion")
                    .font(.headline)
                HStack(spacing: 8) {
                    aqiBadge
                    Text(sim.aqiCategory)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "lungs.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .secondary)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var aqiBadge: some View {
        Text("AQI \(sim.aqi)")
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(aqiColor(), in: Capsule())
            .foregroundStyle(.white)
    }

    private func aqiColor() -> Color {
        switch sim.aqi {
        case ..<51: return .green
        case 51..<101: return .yellow
        case 101..<151: return .orange
        case 151..<201: return .red
        case 201..<301: return .purple
        default: return .brown
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            // Time of day
            HStack(spacing: 10) {
                Image(systemName: "clock")
                Slider(value: $sim.timeOfDay, in: 0...24) { Text("Time") }
                Text("\(Int(sim.timeOfDay))h").frame(width: 44, alignment: .trailing)
            }

            // Wind speed + direction
            HStack(spacing: 10) {
                Image(systemName: "wind")
                Slider(value: $sim.windSpeed, in: 0...8)
                Text(String(format: "%.1f m/s", sim.windSpeed)).frame(width: 80, alignment: .trailing)
            }
            HStack(spacing: 10) {
                Image(systemName: "arrow.clockwise.circle")
                Slider(value: $sim.windDirectionDeg, in: 0...360)
                Text("\(Int(sim.windDirectionDeg))°").frame(width: 60, alignment: .trailing)
            }

            // Emissions
            HStack(spacing: 10) {
                Image(systemName: "car.fill")
                Slider(value: $sim.emissions, in: 0...1)
                Text(String(format: "%.0f%%", sim.emissions * 100)).frame(width: 55, alignment: .trailing)
            }

            // Inversion height
            Toggle("Auto inversion", isOn: $sim.autoInversion)
            if !sim.autoInversion {
                HStack(spacing: 10) {
                    Image(systemName: "rectangle.compress.vertical")
                    Slider(value: $sim.capHeight, in: 0.4...2.0)
                    Text(String(format: "%.1fm", sim.capHeight)).frame(width: 60, alignment: .trailing)
                }
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "heart.text.square")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(healthTip(for: sim.aqi))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func startTimer() {
        playing = true
        // Small stepping of sim time when user isn’t scrubbing; RealityKit drives per-frame updates
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if !playing { t.invalidate() }
        }
    }
}

private func healthTip(for aqi: Int) -> String {
    switch aqi {
    case ..<51: return "Good: Enjoy outdoor activities."
    case 51..<101: return "Moderate: Sensitive groups should reduce prolonged exertion."
    case 101..<151: return "USG: Consider limiting outdoor exertion; close windows if irritated."
    case 151..<201: return "Unhealthy: Move activity indoors; wear a high‑quality mask if needed."
    case 201..<301: return "Very Unhealthy: Avoid outdoor exertion; use air purifier if available."
    default: return "Hazardous: Stay indoors with clean air; avoid all outdoor exertion."
    }
}


#Preview {
    InversionOverlayView()
        .preferredColorScheme(.dark)
}
