//
//  SignalsViewModel.swift
//  AQI
//
//  Created by Aniket prasad on 15/1/26.
//

import SwiftUI
import Combine

final class SignalsViewModel: ObservableObject {
    let sections: [SignalSection] = [
        SignalSection(
            title: "Daily Air Preparedness",
            items: [
                SignalItem(title: "Bad Air Day", iconName: "cloud.fill", tintColor: Color(red: 0.56, green: 0.6, blue: 0.67)),
                SignalItem(title: "High PM2.5 Exposure", iconName: "drop.fill", tintColor: Color(red: 0.36, green: 0.74, blue: 0.9)),
                SignalItem(title: "Outdoor Activity on Polluted Days", iconName: "figure.walk", tintColor: Color(red: 0.38, green: 0.83, blue: 0.59)),
                SignalItem(title: "Indoor Air Protection", iconName: "house.fill", tintColor: Color(red: 0.46, green: 0.64, blue: 0.92))
            ]
        ),
        SignalSection(
            title: "Body Signals",
            items: [
                SignalItem(title: "Breathing Discomfort", iconName: "lungs.fill", tintColor: Color(red: 0.86, green: 0.62, blue: 0.62)),
                SignalItem(title: "Eye & Throat Irritation", iconName: "eye.fill", tintColor: Color(red: 0.84, green: 0.66, blue: 0.34)),
                SignalItem(title: "Unusual Fatigue", iconName: "face.dashed", tintColor: Color(red: 0.68, green: 0.62, blue: 0.86))
            ]
        ),
        SignalSection(
            title: "Environmental Exposure",
            items: [
                SignalItem(title: "Traffic & Road Exposure", iconName: "car.fill", tintColor: Color(red: 0.64, green: 0.7, blue: 0.82)),
                SignalItem(title: "Smoke & Burning Nearby", iconName: "flame.fill", tintColor: Color(red: 0.96, green: 0.55, blue: 0.29)),
                SignalItem(title: "Dense Urban Areas", iconName: "building.2.fill", tintColor: Color(red: 0.6, green: 0.68, blue: 0.85))
            ]
        )
    ]
}
