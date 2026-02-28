//
//  PrecautionView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

struct PrecautionView: View {
    @StateObject private var viewModel = PrecautionViewModel()
    @State private var selectedGuide: AQIGuideNav?
    @State private var showAboutSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                let columns = [GridItem(.flexible(), spacing: 0)]
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(viewModel.ranges) { range in
                        PrecautionCardView(range: range) {
                            selectedGuide = AQIGuideNav(kind: AQIGuideKind.from(range: range), accentColor: range.accentColor)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Precaution")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAboutSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                    }
                    .accessibilityLabel("About")
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedGuide) { nav in
                switch nav.kind {
                case .good:
                    StepGuide_0_50_View(accentColor: nav.accentColor)
                case .moderate:
                    StepGuide_51_100_View(accentColor: nav.accentColor)
                case .usg:
                    StepGuide_101_150_View(accentColor: nav.accentColor)
                case .unhealthy:
                    StepGuide_151_200_View(accentColor: nav.accentColor)
                case .veryUnhealthy:
                    StepGuide_201_300_View(accentColor: nav.accentColor)
                case .hazardous:
                    StepGuide_301_Plus_View(accentColor: nav.accentColor)
                }
            }
            .sheet(isPresented: $showAboutSheet) {
                PrecautionAboutSheetView()
            }
        }
    }
}

#Preview {
    PrecautionView()
        .preferredColorScheme(.dark)
}

// MARK: - Routing model for specific AQI guide screens
struct AQIGuideNav: Identifiable, Hashable {
    let id = UUID()
    let kind: AQIGuideKind
    let accentColor: Color
}

enum AQIGuideKind: Hashable {
    case good
    case moderate
    case usg
    case unhealthy
    case veryUnhealthy
    case hazardous

    static func from(range: AQIRange) -> AQIGuideKind {
        switch range.category {
        case .good_0_50: return .good
        case .moderate_51_100: return .moderate
        case .usg_101_150: return .usg
        case .unhealthy_151_200: return .unhealthy
        case .veryUnhealthy_201_300: return .veryUnhealthy
        case .hazardous_300_plus: return .hazardous
        }
    }
}

private struct PrecautionAboutSheetView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("About")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.primary)
                        .accessibilityAddTraits(.isHeader)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Air pollution is often invisible, but fine particles like PM2.5 can still affect our health. The World Health Organization (WHO) recognizes air pollution as a major global health risk.")

                        Text("This app helps you understand what air quality numbers mean in daily life. It translates AQI levels into clear precautions, highlights body signals you may notice on polluted days, and offers short educational articles to build awareness. Interactive AR features make invisible pollution patterns easier to visualize and understand.")

                        Text("The goal is simple: turn air quality data into practical, intuitive guidance.")
                    }
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(3)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Data & Disclaimer")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Health guidance in this app is informed by publicly available standards from WHO")

                        Text("AR visualizations are designed for educational and awareness purposes and may not represent exact real-time environmental conditions.")

                        Text("This app is for awareness and educational purposes only and does not replace professional medical advice.")
                    }
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(3)

                    VStack(alignment: .leading, spacing: 14) {
                        Text("3D Model Credit")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("“Tiny City” (https://skfb.ly/6xOOr) by Matheus Dalla is licensed under Creative Commons Attribution 4.0 (http://creativecommons.org/licenses/by/4.0/).")
                    }
                    .font(.body)
                    .foregroundStyle(.primary)
                    .lineSpacing(3)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
                .frame(maxWidth: 700, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
    }
}
