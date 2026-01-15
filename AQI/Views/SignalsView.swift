//
//  SignalsView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

struct SignalsView: View {
    @StateObject private var viewModel = SignalsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.sections) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(title: section.title.uppercased())
                            VStack(spacing: 8) {
                                ForEach(section.items) { item in
                                    NavigationLink(destination: destinationView(for: item.kind)) {
                                        SignalRowView(item: item)
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color(red: 0.13, green: 0.13, blue: 0.17))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Signals")
            .background(Color(red: 0.08, green: 0.08, blue: 0.11))
        }
    }
}

#Preview {
    SignalsView()
        .preferredColorScheme(.dark)
}

// MARK: - Private helpers
extension SignalsView {
    @ViewBuilder
    func destinationView(for kind: BodySignalKind) -> some View {
        switch kind {
        case .breathingDiscomfort:
            BreathingDiscomfortView()
        case .eyeThroatIrritation:
            EyeThroatIrritationView()
        case .unusualFatigue:
            UnusualFatigueView()
        case .headacheHeavyHead:
            HeadacheHeavyHeadView()
        case .poorFocusBrainFog:
            PoorFocusBrainFogView()
        case .lowEnergy:
            LowEnergyView()
        case .noseIrritation:
            NoseIrritationView()
        case .poorSleep:
            PoorSleepView()
        }
    }
}
