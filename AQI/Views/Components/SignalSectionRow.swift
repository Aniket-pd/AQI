import SwiftUI

struct SignalDetailSection: Identifiable {
    let id = UUID()
    let title: String
    var body: String? = nil
    var bullets: [String]? = nil
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

            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)

                if let body = section.body, !body.isEmpty {
                    Text(body)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let bullets = section.bullets, !bullets.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(bullets, id: \.self) { b in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Text(b)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.top, section.body == nil ? 0 : 2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
