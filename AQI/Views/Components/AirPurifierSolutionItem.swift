//
//  AirPurifierSolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

struct AirPurifierSolutionItem: View {
    let status: String
    private let brand: Color = .teal

    var body: some View {
        SolutionItem(
            type: .airPurifier,
            status: status,
            iconColor: brand,
            titleColor: brand,
            statusColor: brand.opacity(0.7)
        )
    }
}

#Preview {
    AirPurifierSolutionItem(status: "Turn On")
        .padding()
        .background(Color(.systemBackground))
}

