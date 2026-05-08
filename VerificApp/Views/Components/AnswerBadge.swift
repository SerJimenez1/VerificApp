import SwiftUI

struct AnswerBadge: View {
    let answer: VerificationAnswer?

    var body: some View {
        Text(answer?.label ?? "Sin responder")
            .font(.caption.weight(.bold))
            .foregroundStyle(answer == nil ? Color.white.opacity(0.70) : AppPalette.ink)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AppPalette.color(for: answer), in: Capsule())
            .lineLimit(1)
    }
}
