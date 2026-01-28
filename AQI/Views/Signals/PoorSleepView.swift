import SwiftUI

struct PoorSleepView: View {
    var body: some View {
        SignalDetailView(
            title: "Poor sleep",
            subtitle: "Restlessness or low sleep quality.",
            sections: [
                .init(title: "What this signal is?", body: "Restlessness at night, waking often, or feeling unrefreshed in the morning."),
                .init(title: "Why it can happen on polluted days", body: "Irritants can bother the airways and eyes, making it harder to fall asleep or stay asleep. Poor air can also affect overall comfort."),
                .init(title: "What you can do right now?", body: "Use an air purifier in the bedroom if available, keep windows closed when AQI is high, avoid caffeine late in the day, and keep the room cool, dark, and quiet."),
                .init(title: "When to get extra help", body: "If you experience breathing issues at night or ongoing insomnia despite cleaner air, consider medical advice.")
            ],
            accentColor: Color(red: 0.56, green: 0.60, blue: 0.80),
            iconName: "bed.double.fill"
        )
    }
}
