import SwiftUI

enum AppPalette {
    static let ink = Color(red: 0.05, green: 0.06, blue: 0.09)
    static let panel = Color.white.opacity(0.10)
    static let panelStrong = Color.white.opacity(0.16)
    static let mint = Color(red: 0.20, green: 0.90, blue: 0.72)
    static let lime = Color(red: 0.78, green: 0.96, blue: 0.35)
    static let coral = Color(red: 1.00, green: 0.39, blue: 0.35)
    static let amber = Color(red: 1.00, green: 0.76, blue: 0.22)
    static let violet = Color(red: 0.58, green: 0.44, blue: 1.00)

    static let background = LinearGradient(
        colors: [
            Color(red: 0.04, green: 0.05, blue: 0.08),
            Color(red: 0.03, green: 0.20, blue: 0.18),
            Color(red: 0.28, green: 0.08, blue: 0.17)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func color(for verdict: Verdict) -> Color {
        switch verdict {
        case .probablyTrue:
            return mint
        case .doubtful:
            return amber
        case .probablyFalse:
            return coral
        }
    }

    static func color(for answer: VerificationAnswer?) -> Color {
        switch answer {
        case .yes:
            return mint
        case .no:
            return coral
        case .notApplicable:
            return violet
        case .none:
            return Color.white.opacity(0.55)
        }
    }
}

struct AppBackground: View {
    var body: some View {
        AppPalette.background
            .overlay {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.10),
                        Color.clear,
                        Color.black.opacity(0.12)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
    }
}

extension View {
    func verificPanel(padding: CGFloat = 16) -> some View {
        self
            .padding(padding)
            .background(AppPalette.panel, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 1)
            }
    }
}
