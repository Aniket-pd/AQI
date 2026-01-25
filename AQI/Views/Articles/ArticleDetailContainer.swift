//
//  ArticleDetailContainer.swift
//  AQI
//
//  Created by Assistant on 25/1/26.
//

import SwiftUI

struct ArticleDetailContainer: View {
    let article: Article

    var body: some View {
        Group {
            switch article.kind {
            case .cardio:
                CardioArticleView(article: article)
            case .epilepsy:
                EpilepsyArticleView(article: article)
            case .aqiIndia:
                AQIIndiaArticleView(article: article)
            }
        }
    }
}

