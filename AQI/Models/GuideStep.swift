//
//  GuideStep.swift
//  AQI
//
//  Created by Assistant on 15/1/26.
//

import Foundation

struct GuideStep: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let content: String
}

