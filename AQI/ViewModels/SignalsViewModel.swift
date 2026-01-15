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
            title: "Body Signals",
            items: [
                SignalItem(title: "Breathing discomfort", iconName: "lungs.fill", tintColor: Color(red: 0.86, green: 0.62, blue: 0.62), kind: .breathingDiscomfort),
                SignalItem(title: "Eye and throat irritation", iconName: "eye.fill", tintColor: Color(red: 0.84, green: 0.66, blue: 0.34), kind: .eyeThroatIrritation),
                SignalItem(title: "Unusual fatigue", iconName: "bolt.slash.fill", tintColor: Color(red: 0.68, green: 0.62, blue: 0.86), kind: .unusualFatigue),
                SignalItem(title: "Headache / heavy head", iconName: "waveform.path.ecg", tintColor: Color(red: 0.58, green: 0.72, blue: 0.86), kind: .headacheHeavyHead),
                SignalItem(title: "Poor focus / brain fog", iconName: "brain", tintColor: Color(red: 0.38, green: 0.83, blue: 0.59), kind: .poorFocusBrainFog),
                SignalItem(title: "Feeling low on energy", iconName: "battery.25", tintColor: Color(red: 0.96, green: 0.73, blue: 0.20), kind: .lowEnergy),
                SignalItem(title: "Nose irritation", iconName: "aqi.low", tintColor: Color(red: 0.72, green: 0.64, blue: 0.78), kind: .noseIrritation),
                SignalItem(title: "Poor sleep", iconName: "bed.double.fill", tintColor: Color(red: 0.56, green: 0.60, blue: 0.80), kind: .poorSleep)
            ]
        )
    ]
}
