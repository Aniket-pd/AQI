import SwiftUI

struct UnusualFatigueView: View {
    var body: some View {
        SignalDetailView(
            title: "Unusual fatigue",
            subtitle: "Feeling unusually tired or low stamina.",
            sections: [
                .init(title: "What this signal is", body: "Unusual fatigue means feeling far more tired than normal, even after resting. You may feel weak, heavy, or lacking energy to do daily activities. This tiredness can appear suddenly and feel different from regular tiredness."),
                .init(title: "Why it can happen on polluted days", body: "Breathing polluted air can place extra stress on your body. When your body is working to stay comfortable in dirty air, it may leave you feeling worn out. This can result in a deeper sense of fatigue than usual."),
                .init(title: "What you can do right now", bullets: [
                    "Rest in a clean and quiet space",
                    "Drink water to stay hydrated",
                    "Avoid heavy physical or mental activity"
                ]),
                .init(title: "When to get extra help", body: "If extreme tiredness does not improve with rest or feels overwhelming, seek medical advice.")
            ],
            accentColor: Color(red: 0.68, green: 0.62, blue: 0.86),
            iconName: "bolt.slash.fill",
            sources: [
                "https://newsinhealth.nih.gov/2011/07/bad-air-day",
                "https://www.cdc.gov/wildfires/risk-factors/index.html"
            ]
        )
    }
}
