//
//  AQIRange.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct AQIRange: Identifiable {
    let id = UUID()
    let title: String
    let aqiRange: String
    let summary: String
    let detail: String
    let iconName: String
    let accentColor: Color
    let buttonTitle: String
}
