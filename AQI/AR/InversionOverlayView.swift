import SwiftUI

struct InversionOverlayView: View {
    @StateObject private var vm = InversionViewModel()
    @State private var showInfo = false
    

    var body: some View {
        ZStack {
            InversionARView(viewModel: vm)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                header
                Spacer()
                stabilityControl
            }
            .padding()
        }
        .sheet(isPresented: $showInfo) { infoSheet }
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
