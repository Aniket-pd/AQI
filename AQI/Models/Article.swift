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

    var heroGradient: [Color] {
        switch kind {
        case .cardiovascular:
            return [Color(red: 0.65, green: 0.06, blue: 0.18), Color(red: 0.9, green: 0.27, blue: 0.35)]
        case .epilepsy:
            return [Color(red: 0.31, green: 0.65, blue: 0.95), Color(red: 0.61, green: 0.77, blue: 0.96)]
        case .aqiIndia:
            return [Color(red: 0.9, green: 0.63, blue: 0.26), Color(red: 0.95, green: 0.42, blue: 0.2)]
        }
    }

    var heroImageName: String {
        switch kind {
        case .cardiovascular:
            return "Cardiovascular"
        case .epilepsy:
            return "Epilepsy"
        case .aqiIndia:
            return "Heat_inversion"
        }
    }
}
