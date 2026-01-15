import SwiftUI

struct NoseIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Nose irritation",
            subtitle: "Sneezing, dryness, or irritation.",
            points: [
                "Use saline nasal spray for relief.",
                "Avoid smoke and perfumed products.",
                "Maintain indoor humidity at comfortable levels.",
                "Reduce outdoor exposure during high AQI."
            ],
            accentColor: Color(red: 0.72, green: 0.64, blue: 0.78),
            iconName: "aqi.low"
        )
    }
}

