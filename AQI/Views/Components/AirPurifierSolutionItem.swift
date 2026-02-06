//
//  AirPurifierSolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

struct AirPurifierSolutionItem: View {
    let status: String

    var body: some View {
        SolutionItem(type: .airPurifier, status: status)
    }
}

#Preview {
    AirPurifierSolutionItem(status: "Turn On")
        .padding()
        .background(Color(.systemBackground))
}
