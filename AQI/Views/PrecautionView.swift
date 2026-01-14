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

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.ranges) { range in
                        PrecautionCardView(range: range)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .navigationTitle("Precaution")
            .background(Color(red: 0.08, green: 0.08, blue: 0.11))
        }
    }
}

#Preview {
    PrecautionView()
        .preferredColorScheme(.dark)
}
