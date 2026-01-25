//
//  Article.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

enum ArticleKind: String {
    case cardiovascular
    case epilepsy
    case aqiIndia
}

struct Article: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let sectionCount: String
    let bannerSymbol: String
    let gradientColors: [Color]
    let kind: ArticleKind
}

extension Article {
    var hasARExperience: Bool {
        switch kind {
        case .cardiovascular, .epilepsy:
            return true
        case .aqiIndia:
            return false
        }
    }
}
