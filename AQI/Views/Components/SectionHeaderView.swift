//
//  SectionHeaderView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundColor(.white.opacity(0.45))
            .padding(.leading, 4)
    }
}

#Preview {
    SectionHeaderView(title: "DAILY AIR PREPAREDNESS")
        .padding()
        .background(Color.black)
        .preferredColorScheme(.dark)
}
