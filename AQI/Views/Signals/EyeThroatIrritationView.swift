import SwiftUI

struct EyeThroatIrritationView: View {
    var body: some View {
        SignalDetailView(
            title: "Eye and throat irritation",
            subtitle: "Stinging eyes, scratchy throat, or dryness.",
            points: [
                "Rinse eyes with clean water if irritated.",
                "Stay hydrated; warm fluids can soothe the throat.",
                "Avoid smoke and polluted outdoor air.",
                "Use a humidifier to reduce dryness indoors."
            ],
            accentColor: Color(red: 0.84, green: 0.66, blue: 0.34),
            iconName: "eye.fill"
        )
    }
}

