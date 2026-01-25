//
//  Article.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

enum ArticleKind: String, Codable, Hashable {
    case cardio
    case epilepsy
    case aqiIndia
}

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let body: String
    let sectionCount: String
    let bannerSymbol: String
    let gradientColors: [Color]
    let kind: ArticleKind
}
