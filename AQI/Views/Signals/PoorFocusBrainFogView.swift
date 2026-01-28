import SwiftUI

struct PoorFocusBrainFogView: View {
    var body: some View {
        SignalDetailView(
            title: "Poor focus / brain fog",
            subtitle: "Difficulty concentrating or mental cloudiness.",
            sections: [
                .init(title: "What this signal is?", body: "It’s harder to concentrate or think clearly. Tasks may feel slower and you might forget small details more easily."),
                .init(title: "Why it can happen on polluted days", body: "Air pollutants can affect oxygen exchange and may trigger inflammation that impacts how alert and clear‑headed you feel."),
                .init(title: "What you can do right now?", body: "Take short breaks, move to a cleaner indoor area, stay hydrated, and shift to lighter tasks until your focus improves."),
                .init(title: "When to get extra help", body: "If confusion is severe, sudden, or accompanied by other concerning symptoms, seek medical advice.")
            ],
            accentColor: Color(red: 0.38, green: 0.83, blue: 0.59),
            iconName: "brain"
        )
    }
}
