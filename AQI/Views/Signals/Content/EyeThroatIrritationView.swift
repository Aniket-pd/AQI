import SwiftUI

struct EyeThroatIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Eye and throat irritation",
            subtitle: "Stinging eyes, scratchy throat, or dryness.",
            sections: [
                .init(title: "What this signal is", body: "Eye and throat irritation means a burning, itchy, or scratchy feeling in the eyes or throat. Your eyes may water, feel dry, or sting, and your throat may feel sore or uncomfortable when you swallow. This irritation can make you want to rub your eyes or clear your throat often."),
                .init(title: "Why it can happen on polluted days", body: "Polluted air may contain smoke, dust, ozone, and fine particles that irritate sensitive tissues. When these pollutants touch the eyes or throat, they can cause inflammation and dryness. This reaction makes the eyes and throat feel sore, itchy, or uncomfortable."),
                .init(title: "What you can do right now", bullets: [
                    "Rinse your eyes gently with clean water and avoid rubbing them",
                    "Sip water or warm fluids to soothe your throat",
                    "Stay indoors and close windows until air quality improves"
                ]),
                .init(title: "When to get extra help", body: "If irritation is severe, painful, or does not improve after being in clean air, seek medical advice.")
            ],
            accentColor: BodySignalKind.eyeThroatIrritation.accentColor,
            iconName: BodySignalKind.eyeThroatIrritation.iconName
        )
    }
}

#Preview {
    EyeThroatIrritationView()
}
