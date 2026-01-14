//
//  Article.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let sectionCount: String
    let bannerSymbol: String
    let gradientColors: [Color]
}
