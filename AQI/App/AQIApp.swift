//
//  AQIApp.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

@main
struct AQIApp: App {
    init() {
        ARAssetWarmup.shared.prepareIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
