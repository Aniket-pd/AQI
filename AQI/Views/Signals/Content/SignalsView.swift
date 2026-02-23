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
                                // Use the native List/NavigationLink chevron (don’t draw a custom one)
                                SignalRowView(item: item, showsChevron: false)
                            }
                        }
                    } header: {
                        Text(section.title)
                            .textCase(nil)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
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
