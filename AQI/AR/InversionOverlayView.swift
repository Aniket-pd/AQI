import SwiftUI

struct InversionOverlayView: View {
    @StateObject private var vm = InversionViewModel()
    @State private var showInfo = false
    @State private var caption: String = ""
    @State private var captionOpacity: Double = 0
    @State private var lastStage: Int = -1

    var body: some View {
        ZStack {
            InversionARView(viewModel: vm)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                header
                Spacer()
                stabilityControl
                captionView
            }
            .padding()
        }
        .sheet(isPresented: $showInfo) { infoSheet }
        .onChange(of: vm.stability) { _, s in
            updateCaption(for: s)
        }
        .onAppear { updateCaption(for: vm.stability) }
    }

    private var captionView: some View {
        Text(caption)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
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
                Text("Atmospheric Stability")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text(vm.stabilityLabel)
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                }
                Text("Higher stability traps pollution near ground")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button { showInfo = true } label: { Image(systemName: "info.circle").font(.title3) }
                .buttonStyle(.plain)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var stabilityControl: some View {
        HStack(spacing: 12) {
            Image(systemName: "thermometer.sun")
            Slider(value: $vm.stability, in: 0...1)
            Image(systemName: "thermometer.snowflake")
        }
        .tint(.secondary)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var infoSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Capsule().frame(width: 40, height: 5).foregroundStyle(.secondary).opacity(0.3)
                .frame(maxWidth: .infinity)
            Text("Temperature Inversion")
                .font(.title2.bold())
            Text("Pollution isn’t higher because more is produced; it’s higher because stable, warmer air aloft prevents vertical escape. Particles slow at an invisible boundary, spread sideways, and accumulate in street canyons.")
            Text("Slide the ‘Atmospheric Stability’ control from Normal to Severe to see warm (red) air forming a stable cap above cool (blue) air, trapping pollution beneath.")
            Spacer()
        }
        .padding()
        .presentationDetents([.fraction(0.35), .medium])
    }

    
}

#Preview {
    InversionOverlayView()
        .preferredColorScheme(.dark)
}
