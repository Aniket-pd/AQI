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
                {
                    let kind: BodySignalKind = .breathingDiscomfort
                    return SignalItem(title: "Breathing discomfort", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .eyeThroatIrritation
                    return SignalItem(title: "Eye and throat irritation", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .unusualFatigue
                    return SignalItem(title: "Unusual fatigue", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .headacheHeavyHead
                    return SignalItem(title: "Headache / heavy head", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .poorFocusBrainFog
                    return SignalItem(title: "Poor focus / brain fog", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .lowEnergy
                    return SignalItem(title: "Feeling low on energy", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .noseIrritation
                    return SignalItem(title: "Nose irritation", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }(),
                {
                    let kind: BodySignalKind = .poorSleep
                    return SignalItem(title: "Poor sleep", iconName: kind.iconName, tintColor: kind.accentColor, kind: kind)
                }()
            ]
        )
    ]
}
