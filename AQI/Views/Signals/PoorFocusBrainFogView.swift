import SwiftUI

struct PoorFocusBrainFogView: View {
    var body: some View {
        SignalDetailView(
            title: "Poor focus / brain fog",
            subtitle: "Difficulty concentrating or mental cloudiness.",
            points: [
                "Take short breaks to reset focus.",
                "Prefer indoor tasks with cleaner air.",
                "Maintain hydration and light nutrition.",
                "Schedule demanding tasks when you feel clearer."
            ],
            accentColor: Color(red: 0.38, green: 0.83, blue: 0.59),
            iconName: "brain"
        )
    }
}

