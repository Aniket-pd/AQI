import SwiftUI

struct LowEnergyView: View {
    var body: some View {
        SignalDetailView(
            title: "Feeling low on energy",
            subtitle: "Low motivation or sluggishness.",
            sections: [
                .init(title: "What this signal is?", body: "A general feeling of sluggishness or reduced motivation, where everyday tasks feel more demanding than usual."),
                .init(title: "Why it can happen on polluted days", body: "Pollutants can affect breathing and sleep quality, and trigger inflammation that makes your body feel more fatigued than normal."),
                .init(title: "What you can do right now?", body: "Rest when needed, hydrate, and try light stretching indoors. Opt for simple meals and plan lighter tasks until air quality improves."),
                .init(title: "When to get extra help", body: "If fatigue is severe, accompanied by chest pain, dizziness, or doesn’t improve with rest and cleaner air, consider medical advice.")
            ],
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.20),
            iconName: "battery.25"
        )
    }
}

#Preview {
    LowEnergyView()
}
