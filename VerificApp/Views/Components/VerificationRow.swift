import SwiftUI

struct VerificationRow: View {
    let record: VerificationRecord

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: record.verdict.symbolName)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppPalette.color(for: record.verdict))
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 8) {
                Text(record.titleOrURL)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    VerdictBadge(verdict: record.verdict)
                    Text("\(record.affirmativeCount)/6 sí")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.70))
                }

                Text(record.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(Color.white.opacity(0.58))
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}
