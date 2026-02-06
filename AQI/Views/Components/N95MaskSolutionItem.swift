//
//  N95MaskSolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

struct N95MaskSolutionItem: View {
    let status: String
    private let brand: Color = .blue

    var body: some View {
        SolutionItem(
            type: .n95Mask,
            status: status,
            iconColor: brand,
            titleColor: brand,
            statusColor: brand.opacity(0.7)
        )
    }
}

#Preview {
    N95MaskSolutionItem(status: "Recommended")
        .padding()
        .background(Color(.systemBackground))
}

