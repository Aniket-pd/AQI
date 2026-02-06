//
//  StayIndoorSolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

struct StayIndoorSolutionItem: View {
    let status: String
    private let brand: Color = .indigo

    var body: some View {
        SolutionItem(
            type: .stayIndoor,
            status: status,
            iconColor: brand,
            titleColor: brand,
            statusColor: brand.opacity(0.7)
        )
    }
}

#Preview {
    StayIndoorSolutionItem(status: "Stay Indoor")
        .padding()
        .background(Color(.systemBackground))
}

