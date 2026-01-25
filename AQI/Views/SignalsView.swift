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
            List {
                ForEach(viewModel.sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            NavigationLink(destination: destinationView(for: item.kind)) {
                                // Let List show the chevron to match HIG
                                SignalRowView(item: item, showsChevron: false)
                            }
                        }
                    } header: {
                        Text(section.title)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.primary)
                            .padding(.leading, 4)
                            .padding(.bottom, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Signals")
            .navigationBarTitleDisplayMode(.large)
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
