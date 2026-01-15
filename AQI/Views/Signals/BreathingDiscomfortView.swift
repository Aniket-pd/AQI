import SwiftUI

struct BreathingDiscomfortView: View {
    var body: some View {
        SignalDetailView(
            title: "Breathing discomfort",
            subtitle: "Shortness of breath or tightness in chest.",
            points: [
                "Reduce outdoor activity and avoid heavy exertion.",
                "Move indoors; use an air purifier if available.",
                "Use a high‑filtration mask when outside.",
                "If symptoms worsen, seek medical advice."
            ],
            accentColor: Color(red: 0.86, green: 0.62, blue: 0.62),
            iconName: "lungs.fill"
        )
    }
}

