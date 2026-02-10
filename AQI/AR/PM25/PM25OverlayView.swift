import SwiftUI

struct PM25OverlayView: View {
    @StateObject private var vm = PM25OverlayViewModel()
    @State private var showInfo = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // AR background
            PM25ARView(viewModel: vm)
                .id("pm25-ar-view")
                .edgesIgnoringSafeArea(.all)

            // UI overlay
            VStack {
                topInfoCard
                Spacer()
                controls
            }
            .padding()
            // Info overlay (custom, non-modal to avoid AR resets)
            if showInfo {
                // Tappable backdrop to dismiss
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.easeInOut) { showInfo = false } }

                infoSheet
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Material.ultraThin)
                    )
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut, value: showInfo)
    }

    private var topInfoCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("PM2.5 right now")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(vm.displayValue)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                    Text("µg/m³")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Text(vm.qualityLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            Button {
                showInfo = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var controls: some View {
        VStack(spacing: 12) {
            // Educational disclaimer (concise, always visible)
            Text("This AR visualization is symbolic for learning. Particles are enlarged/simplified and not to scale or physically accurate.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 12) {
                Image(systemName: "aqi.low")
                Slider(value: $vm.pm25, in: 0...300, step: 1)
                Image(systemName: "aqi.high")
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var infoSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule().frame(width: 40, height: 5).foregroundStyle(.secondary).opacity(0.3)
                .frame(maxWidth: .infinity)
            Text("What am I seeing?")
                .font(.title2.bold())
            Text("You’re seeing a live particle field that represents PM2.5 (micrograms per cubic meter). More particles and faster motion means higher concentrations. Colors stay soft and neutral so it blends into your space.")
            Text("Interact by tapping to create a pulse or swiping to push particles aside.")
            // Detailed educational clarification for WWDC SSC quality standards
            VStack(alignment: .leading, spacing: 8) {
                Text("Educational Note")
                    .font(.headline)
                Text("This AR experience is designed purely for visual and educational purposes—to help you understand that PM2.5 particles exist in the air around us and to raise awareness about air pollution.")
                Text("The visualization does not represent the actual size, density, or physical behavior of real PM2.5. In reality, PM2.5 are extremely small (2.5 micrometers or smaller) and cannot be seen with the naked eye. The particles shown here are enlarged and simplified to make the concept easier to understand.")
                Text("Please consider this a symbolic visualization for awareness and learning—not a scientifically accurate physical representation.")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut) { showInfo = false }
                } label: {
                    Text("Close")
                        .font(.callout.weight(.semibold))
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        .padding(12)
    }
}

#Preview {
    PM25OverlayView()
        .preferredColorScheme(.dark)
}
