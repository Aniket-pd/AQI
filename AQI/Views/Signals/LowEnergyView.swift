import SwiftUI

struct LowEnergyView: View {
    var body: some View {
        SignalDetailView(
            title: "Feeling low on energy",
            subtitle: "Low motivation or sluggishness.",
            points: [
                "Get adequate rest and short naps if needed.",
                "Light stretching indoors to gently re‑energize.",
                "Balanced snacks and water to support energy.",
                "Plan lighter tasks on poor‑air days."
            ],
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.20),
            iconName: "battery.25"
        )
    }
}

