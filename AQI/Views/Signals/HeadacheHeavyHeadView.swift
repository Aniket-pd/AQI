import SwiftUI

struct HeadacheHeavyHeadView: View {
    var body: some View {
        SignalDetailView(
            title: "Headache / heavy head",
            subtitle: "Dull, persistent head discomfort.",
            sections: [
                .init(title: "What this signal is", body: "A headache or heavy head feels like pressure, tightness, or aching in the head. It may feel as though your head is weighed down or squeezed. This discomfort can make it hard to relax or concentrate."),
                .init(title: "Why it can happen on polluted days", body: "Polluted air can irritate the body and trigger headache symptoms. Smoke, fine particles, and gases may cause tension or discomfort in the head. When the air is unhealthy, the head may feel heavier or more sensitive."),
                .init(title: "What you can do right now", bullets: [
                    "Rest in a clean, quiet place",
                    "Drink water to stay hydrated",
                    "Relax and breathe slowly"
                ]),
                .init(title: "When to get extra help", body: "If headaches are severe, sudden, or do not improve, seek medical advice.")
            ],
            accentColor: Color(red: 0.58, green: 0.72, blue: 0.86),
            iconName: "waveform.path.ecg",
            sources: [
                "https://www.cdc.gov/wildfires/risk-factors/index.html",
                "https://pmc.ncbi.nlm.nih.gov/articles/PMC9540829/"
            ]
        )
    }
}

#Preview {
    HeadacheHeavyHeadView()
}
