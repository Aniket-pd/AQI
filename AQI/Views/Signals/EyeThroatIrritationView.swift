import SwiftUI

struct EyeThroatIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Eye and throat irritation",
            subtitle: "Stinging eyes, scratchy throat, or dryness.",
            sections: [
                .init(title: "What this signal is?", body: "Irritation can feel like burning, stinging, dryness, or scratchiness in your eyes or throat. You may tear up more than usual or feel the need to clear your throat often."),
                .init(title: "Why it can happen on polluted days", body: "PM2.5, ozone, smoke, and other irritants can inflame and dry the surface of the eyes and throat, making them more sensitive and uncomfortable."),
                .init(title: "What you can do right now?", body: "Rinse eyes gently with clean water, sip warm fluids to soothe your throat, avoid smoke and polluted outdoor air, and use a humidifier to reduce indoor dryness."),
                .init(title: "When to get extra help", body: "Seek medical advice if you have severe pain, vision changes, persistent hoarseness, or symptoms that do not improve after moving to cleaner air.")
            ],
            accentColor: Color(red: 0.84, green: 0.66, blue: 0.34),
            iconName: "eye.fill"
        )
    }
}

#Preview {
    EyeThroatIrritationView()
}
