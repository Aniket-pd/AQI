import SwiftUI

struct PM25OverlayView: View {
    @StateObject private var vm = PM25OverlayViewModel()
    @State private var showInfo = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            // AR background
            PM25ARView(viewModel: vm)
                .edgesIgnoringSafeArea(.all)

            // UI overlay
            VStack {
                topInfoCard
                Spacer()
                controls
            }
            .padding()
        }
        .sheet(isPresented: $showInfo) { infoSheet }
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
            Picker("Mode", selection: $vm.isLive) {
                Text("Demo slider").tag(false)
                Text("Live").tag(true)
            }
            .pickerStyle(.segmented)

            if !vm.isLive {
                HStack(spacing: 12) {
                    Image(systemName: "aqi.low")
                    Slider(value: $vm.pm25, in: 0...300, step: 1)
                    Image(systemName: "aqi.high")
                }
            } else {
                Text("Live mode placeholder: wire to sensor/API")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
            Spacer()
        }
        .padding()
        .presentationDetents([.fraction(0.35), .medium])
    }
}

#Preview {
    PM25OverlayView()
        .preferredColorScheme(.dark)
}
