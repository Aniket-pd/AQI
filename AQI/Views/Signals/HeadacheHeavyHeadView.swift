import SwiftUI

struct HeadacheHeavyHeadView: View {
    var body: some View {
        SignalDetailView(
            title: "Headache / heavy head",
            subtitle: "Dull, persistent head discomfort.",
            points: [
                "Rest in a quiet, well‑ventilated room.",
                "Stay hydrated and avoid exposure to smoke.",
                "Use over‑the‑counter relief if appropriate.",
                "Seek medical advice if severe or persistent."
            ],
            accentColor: Color(red: 0.58, green: 0.72, blue: 0.86),
            iconName: "waveform.path.ecg"
        )
    }
}

