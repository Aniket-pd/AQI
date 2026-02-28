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
    @State private var showInfoSheet = false

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

                Section {
                    EmptyView()
                } footer: {
                    Text("This information is for general awareness only and should not be considered medical advice. If symptoms are severe, persistent, or concerning, seek professional medical guidance.")
                        .textCase(nil)
                }
            }
            .listStyle(.insetGrouped)
            .headerProminence(.increased)
            .navigationTitle("Signals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfoSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                NavigationStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is Signal?")
                            .font(.title2)
                            .bold()

                        Text("In this app, Signals are early physical or mental signs your body may show when air quality affects you. They help you recognize how pollution might be impacting your breathing, focus, energy, sleep, or overall well-being.")

                        Spacer()
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showInfoSheet = false
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
                }
            }
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
