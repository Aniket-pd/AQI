import SwiftUI

struct NoseIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Nose irritation",
            subtitle: "Sneezing, dryness, or irritation.",
            sections: [
                .init(title: "What this signal is?", body: "A dry, scratchy, or burning feeling in your nose. You might sneeze more than usual or feel congested."),
                .init(title: "Why it can happen on polluted days", body: "Dry or polluted air can irritate the lining of your nose, making it inflamed and more sensitive to triggers."),
                .init(title: "What you can do right now?", body: "Use a saline nasal spray, avoid smoke and strong fragrances, and keep indoor humidity comfortable to reduce dryness."),
                .init(title: "When to get extra help", body: "If you have persistent nosebleeds, severe congestion, or irritation that doesn’t improve with cleaner air, consider medical guidance.")
            ],
            accentColor: Color(red: 0.72, green: 0.64, blue: 0.78),
            iconName: "aqi.low"
        )
    }
}
