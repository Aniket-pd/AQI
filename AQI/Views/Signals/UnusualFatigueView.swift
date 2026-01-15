import SwiftUI

struct UnusualFatigueView: View {
    var body: some View {
        SignalDetailView(
            title: "Unusual fatigue",
            subtitle: "Feeling unusually tired or low stamina.",
            points: [
                "Take frequent breaks and rest adequately.",
                "Hydrate and avoid strenuous activity outdoors.",
                "Prioritize indoor activities in cleaner air.",
                "Resume normal activity gradually as you feel better."
            ],
            accentColor: Color(red: 0.68, green: 0.62, blue: 0.86),
            iconName: "bolt.slash.fill"
        )
    }
}

