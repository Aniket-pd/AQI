import SwiftUI

struct InversionOverlayView: View {
    @StateObject private var vm = InversionViewModel()
    @State private var showInfo = false
    @State private var caption: String = ""
    @State private var captionOpacity: Double = 0
    @State private var lastStage: Int = -1
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            InversionARView(viewModel: vm)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                header
                captionView
                Spacer()
                placementHint
                timeOfDayControl
            }
            .padding()

            if showInfo {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.easeInOut) { showInfo = false } }

                infoCard
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
        .onChange(of: vm.timeOfDay) { _, _ in
            updateCaption(for: vm.derivedStability)
        }
        .onAppear { updateCaption(for: vm.derivedStability) }
    }
    
    private var placementHint: some View {
        Group {
            switch vm.placementState {
            case .loadingModel:
                hintLabel("Loading model…")
            case .readyToPlace:
                hintLabel("Tap to place")
            case .placed:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: vm.placementState)
    }

    private func hintLabel(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
    }

    private var captionView: some View {
        Text(caption)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .opacity(captionOpacity)
            .animation(.easeInOut(duration: 0.5), value: captionOpacity)
    }

    private func updateCaption(for s: Double) {
        let stage: Int
        let t = s
        switch t {
        case ..<0.15: stage = 0
        case 0.15..<0.3: stage = 1
        case 0.3..<0.45: stage = 2
        case 0.45..<0.65: stage = 3
        default: stage = 4
        }
        guard stage != lastStage else { return }
        lastStage = stage
        let text: String
        switch stage {
        case 0: text = "Warm air usually rises and carries pollution away."
        case 1: text = "Ground cools; near‑surface air gets denser."
        case 2: text = "Cool air settles; rising slows."
        case 3: text = "A warm layer forms above and lowers mixing height."
        default: text = "Pollution spreads sideways instead of escaping upward."
        }
        captionOpacity = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            caption = text
            captionOpacity = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                captionOpacity = 0.85 // keep lightly visible
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Time of day")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(vm.stabilityLabel)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                }
                Text("Sunlight weakens inversion and clears the air")
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

    private var timeOfDayControl: some View {
        HStack(spacing: 12) {
            Image(systemName: "sunrise.fill")
            Slider(value: $vm.timeOfDay, in: 0...1)
            Image(systemName: "sun.max.fill")
        }
        .tint(.secondary)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule().frame(width: 40, height: 5).foregroundStyle(.secondary).opacity(0.3)
                .frame(maxWidth: .infinity)
            Text("Temperature Inversion")
                .font(.title2.bold())
            Text("Pollution isn’t higher because more is produced; it’s higher because stable, warmer air aloft prevents vertical escape. Particles slow at an invisible boundary, spread sideways, and accumulate in street canyons.")
            Text("Slide the ‘Time of Day’ control from early morning to afternoon to watch the sun rise along an arc. As sunlight increases, the inversion weakens: fog lifts, air mixes, and pollution disperses.")
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
            Spacer(minLength: 0)
        }
        .padding(12)
    }

    
}

#Preview {
    InversionOverlayView()
        .preferredColorScheme(.dark)
}
