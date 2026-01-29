import SwiftUI

struct LowEnergyView: View {
    var body: some View {
        SignalDetailView(
            title: "Feeling low on energy",
            subtitle: "Low motivation or sluggishness.",
            sections: [
                .init(title: "What this signal is", body: "Feeling low on energy means you feel slow, drained, or unmotivated. Even simple tasks may feel harder than usual. You may feel like you need to rest more often."),
                .init(title: "Why it can happen on polluted days", body: "Polluted air can make your body feel stressed and tired. When breathing feels more difficult, your energy levels may drop."),
                .init(title: "What you can do right now", bullets: [
                    "Rest in clean air",
                    "Avoid overexertion",
                    "Drink water"
                ]),
                .init(title: "When to get extra help", body: "If low energy is severe or does not improve, seek medical advice.")
            ],
            accentColor: Color(red: 0.96, green: 0.73, blue: 0.20),
            iconName: "battery.25",
            sources: [
                "https://www.who.int/teams/environment-climate-change-and-health/air-quality-and-health/health-impacts/types-of-pollutants",
                "https://www.cdc.gov/wildfires/risk-factors/index.html"
            ]
        )
    }
}

#Preview {
    LowEnergyView()
}
