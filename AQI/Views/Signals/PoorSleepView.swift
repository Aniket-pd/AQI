import SwiftUI

struct PoorSleepView: View {
    var body: some View {
        SignalDetailView(
            title: "Poor sleep",
            subtitle: "Restlessness or low sleep quality.",
            points: [
                "Use an air purifier in the bedroom.",
                "Avoid caffeine late in the day.",
                "Keep windows closed during high AQI.",
                "Maintain a cool, dark, quiet room."
            ],
            accentColor: Color(red: 0.56, green: 0.60, blue: 0.80),
            iconName: "bed.double.fill"
        )
    }
}

