//
//  SignalModels.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct SignalSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [SignalItem]
}

struct SignalItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let tintColor: Color
}
