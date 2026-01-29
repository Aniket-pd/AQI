import SwiftUI

struct NoseIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Nose irritation",
            subtitle: "Sneezing, dryness, or irritation.",
            sections: [
                .init(title: "What this signal is", body: "Nose irritation includes dryness, itching, burning, sneezing, or a runny nose. You may feel congestion or discomfort inside your nostrils. It can feel similar to mild allergy-like symptoms."),
                .init(title: "Why it can happen on polluted days", body: "Dust, smoke, and fine particles can irritate the lining of the nose. The nose reacts by becoming inflamed or producing more mucus to protect itself."),
                .init(title: "What you can do right now", bullets: [
                    "Gently blow your nose",
                    "Rinse with clean water or saline",
                    "Stay indoors"
                ]),
                .init(title: "When to get extra help", body: "If symptoms are painful, severe, or long-lasting, seek medical advice.")
            ],
            accentColor: Color(red: 0.72, green: 0.64, blue: 0.78),
            iconName: "aqi.low",
            sources: [
                "https://www.cdc.gov/air-quality/pollutants/index.html",
                "https://www.cdc.gov/wildfires/risk-factors/index.html"
            ]
        )
    }
}
