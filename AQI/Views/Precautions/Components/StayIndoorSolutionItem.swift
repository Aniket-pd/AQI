//
//  StayIndoorSolutionItem.swift
//  AQI
//
//  Created by Assistant on 06/02/26.
//

import SwiftUI

struct StayIndoorSolutionItem: View {
    let status: String

    var body: some View {
        SolutionItem(type: .stayIndoor, status: status)
    }
}

#Preview {
    StayIndoorSolutionItem(status: "Stay Indoor")
        .padding()
        .background(Color(.systemBackground))
}
