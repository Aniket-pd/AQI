import SwiftUI

struct UnusualFatigueView: View {
    var body: some View {
        SignalDetailView(
            title: "Unusual fatigue",
            subtitle: "Feeling unusually tired or low stamina.",
            sections: [
                .init(title: "What this signal is?", body: "You feel unusually tired, weak, or low on stamina for everyday tasks."),
                .init(title: "Why it can happen on polluted days", body: "Pollutants can place extra strain on breathing and may trigger inflammation, making you feel more tired than normal."),
                .init(title: "What you can do right now?", body: "Take frequent breaks, hydrate, and avoid strenuous activity outdoors. Prefer indoor activities until air quality improves."),
                .init(title: "When to get extra help", body: "If fatigue is severe, sudden, or doesn’t improve with rest and cleaner air, seek medical advice.")
            ],
            accentColor: Color(red: 0.68, green: 0.62, blue: 0.86),
            iconName: "bolt.slash.fill"
        )
    }
}
