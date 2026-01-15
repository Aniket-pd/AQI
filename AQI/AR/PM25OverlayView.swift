import SwiftUI

struct PM25OverlayView: View {
    @StateObject private var vm = PM25OverlayViewModel()
    @State private var showInfo = false

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

            // Breath button centered bottom
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    breathButton
                }
                .padding([.horizontal, .bottom])
            }
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

            // Adaptive quality control (hidden by default, but handy during dev)
            #if DEBUG
            HStack(spacing: 10) {
                Text("Quality")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Slider(value: $vm.targetComplexity, in: 0.5...1.5)
                    .tint(.secondary)
                Text(String(format: "%.2fx", vm.targetComplexity))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(width: 44, alignment: .trailing)
            }
            #endif
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var breathButton: some View {
        Button {
            // no-op: handled by press states
        } label: {
            HStack(spacing: 8) {
                Image(systemName: vm.breathActive ? "wind" : "wind")
                Text("Breath")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in vm.breathActive = true }
                .onEnded { _ in vm.breathActive = false }
        )
        .buttonStyle(.plain)
    }

    private var infoSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule().frame(width: 40, height: 5).foregroundStyle(.secondary).opacity(0.3)
                .frame(maxWidth: .infinity)
            Text("What am I seeing?")
                .font(.title2.bold())
            Text("You’re seeing a live particle field that represents PM2.5 (micrograms per cubic meter). More particles and faster motion means higher concentrations. Colors stay soft and neutral so it blends into your space.")
            Text("Interact by tapping to create a pulse or swiping to push particles aside. Hold ‘Breath’ to blow a gentle stream.")
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

