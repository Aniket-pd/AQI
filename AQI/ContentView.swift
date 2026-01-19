//
//  ContentView.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PrecautionView()
                .tabItem {
                    Label("Precaution", systemImage: "shield.lefthalf.filled")
                }

            SignalsView()
                .tabItem {
                    Label("Signals", systemImage: "waveform.path.ecg")
                }

            ArticlesView()
                .tabItem {
                    Label("Articles", systemImage: "book.closed")
                }

            PM25OverlayView()
                .tabItem {
                    Label("AR", systemImage: "camera.viewfinder")
                }

            InversionOverlayView()
                .tabItem {
                    Label("Inversion AR", systemImage: "building.2.fill")
                }
        }
        .tint(.white)
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
