import SwiftUI

struct HeadacheHeavyHeadView: View {
    var body: some View {
        SignalDetailView(
            title: "Headache / heavy head",
            subtitle: "Dull, persistent head discomfort.",
            sections: [
                .init(title: "What this signal is?", body: "A steady or throbbing head discomfort that can make your head feel heavy or tight. You might be more sensitive to light, sound, or smells."),
                .init(title: "Why it can happen on polluted days", body: "Air pollution can trigger inflammation and irritation of the sinuses and blood vessels, which may contribute to headaches and a heavy head feeling."),
                .init(title: "What you can do right now?", body: "Rest in a quiet, clean‑air room, hydrate regularly, and avoid smoke or strong odors. Use over‑the‑counter relief if appropriate for you."),
                .init(title: "When to get extra help", body: "Seek care if your headache is severe, sudden, different from your usual, or if it persists despite rest and cleaner air.")
            ],
            accentColor: Color(red: 0.58, green: 0.72, blue: 0.86),
            iconName: "waveform.path.ecg"
        )
    }
}

#Preview {
    HeadacheHeavyHeadView()
}
