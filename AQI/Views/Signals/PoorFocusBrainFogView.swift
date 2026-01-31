import SwiftUI

struct PoorFocusBrainFogView: View {
    var body: some View {
        SignalDetailView(
            title: "Poor focus / brain fog",
            subtitle: "Difficulty concentrating or mental cloudiness.",
            sections: [
                .init(title: "What this signal is", body: "Poor focus or brain fog means your thoughts feel slower or less clear than usual. You may struggle to concentrate, forget small things, or feel mentally tired. It can feel like your mind is “cloudy” or not fully awake."),
                .init(title: "Why it can happen on polluted days", body: "Some research suggests that short-term exposure to air pollution may be linked to temporary changes in attention and thinking. The body’s response to polluted air may affect how alert or focused you feel."),
                .init(title: "What you can do right now", bullets: [
                    "Take a short mental break",
                    "Move to cleaner air",
                    "Rest your eyes and mind"
                ]),
                .init(title: "When to get extra help", body: "If confusion is strong, sudden, or does not improve, seek medical advice.")
            ],
            accentColor: Color(red: 0.38, green: 0.83, blue: 0.59),
            iconName: "brain",
            sources: [
                "https://pmc.ncbi.nlm.nih.gov/articles/PMC6792460/",
                "https://pmc.ncbi.nlm.nih.gov/articles/PMC8622756/"
            ]
        )
    }
}
