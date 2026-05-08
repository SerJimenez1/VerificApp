import SwiftUI

struct VerdictBadge: View {
    let verdict: Verdict

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: verdict.symbolName)
            Text(verdict.shortTitle)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
        }
        .font(.caption.weight(.bold))
        .foregroundStyle(AppPalette.ink)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(AppPalette.color(for: verdict), in: Capsule())
    }
}
