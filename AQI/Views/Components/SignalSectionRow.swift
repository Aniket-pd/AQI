import SwiftUI

struct SignalDetailSection: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

struct SignalSectionRow: View {
    let accentColor: Color
    let section: SignalDetailSection

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(accentColor)
                .frame(width: 8, height: 8)
                .padding(.top, 8)

            VStack(alignment: .leading, spacing: 6) {
                Text(section.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(section.body)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
