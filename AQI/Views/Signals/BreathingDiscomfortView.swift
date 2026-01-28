import SwiftUI

struct BreathingDiscomfortView: View {
    var body: some View {
        SignalDetailView(
            title: "Breathing discomfort",
            subtitle: "Breathing feels heavier or less comfortable than usual.",
            sections: [
                .init(title: "What this signal is?", body: "Breathing discomfort means your breathing feels heavier or less comfortable than usual. You may notice shortness of breath, a tight feeling in your chest, or that it takes more effort to breathe during simple activities."),
                .init(title: "Why it can happen on polluted days", body: "On polluted days, the air contains tiny particles like PM2.5 and gases such as ozone. These can irritate the airways and make breathing feel strained, which may lead to discomfort even while resting."),
                .init(title: "What you can do right now?", body: "Pause outdoor activity and give your body time to recover. Move to an indoor space and keep windows closed if outside air is poor. Focus on slow, calm breathing to help your body relax."),
                .init(title: "When to get extra help", body: "If breathing feels very hard, painful, or continues to feel uncomfortable even after resting in clean air, seek medical advice.")
            ],
            accentColor: Color(red: 0.86, green: 0.62, blue: 0.62),
            iconName: "lungs.fill"
        )
    }
}

#Preview {
    BreathingDiscomfortView()
}
