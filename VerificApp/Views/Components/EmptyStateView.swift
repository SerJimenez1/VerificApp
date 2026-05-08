import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let symbolName: String

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: symbolName)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(AppPalette.lime)

            Text(title)
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            Text(message)
                .font(.callout)
                .foregroundStyle(Color.white.opacity(0.72))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .verificPanel(padding: 24)
    }
}
