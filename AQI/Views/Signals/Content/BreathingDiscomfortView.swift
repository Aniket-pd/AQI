import SwiftUI

struct BreathingDiscomfortView: View {
    var body: some View {
        SignalDetailView(
            title: "Breathing discomfort",
            subtitle: "Breathing feels heavier or less comfortable than usual.",
            sections: [
                .init(title: "What this signal is", body: "Breathing discomfort means your breathing feels heavier, tighter, or less comfortable than usual. You may notice that it takes more effort to breathe, even while doing simple activities. Some people describe it as feeling “air-hungry” or unable to take a full, relaxed breath."),
                .init(title: "Why it can happen on polluted days", body: "On polluted days, the air contains tiny particles (PM2.5) and gases such as ozone. These can irritate the lining of your airways and make breathing feel strained. When the air is not clean, your lungs may feel less at ease, which can lead to a sense of discomfort while breathing."),
                .init(title: "What you can do right now", bullets: [
                    "Pause outdoor activity and rest until your breathing feels easier",
                    "Move to an indoor space and keep windows closed if outside air is poor",
                    "Focus on slow, calm breathing to help your body relax"
                ]),
                .init(title: "When to get extra help", body: "If breathing feels unusually difficult or does not improve after resting in cleaner air, consider seeking medical advice.")
            ],
            accentColor: BodySignalKind.breathingDiscomfort.accentColor,
            iconName: BodySignalKind.breathingDiscomfort.iconName
        )
    }
}

#Preview {
    BreathingDiscomfortView()
}
