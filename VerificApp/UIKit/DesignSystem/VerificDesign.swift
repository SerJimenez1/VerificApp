import UIKit

enum VerificDesign {
    static let ink = UIColor(red: 0.05, green: 0.06, blue: 0.09, alpha: 1)
    static let mint = UIColor(red: 0.20, green: 0.90, blue: 0.72, alpha: 1)
    static let lime = UIColor(red: 0.78, green: 0.96, blue: 0.35, alpha: 1)
    static let coral = UIColor(red: 1.00, green: 0.39, blue: 0.35, alpha: 1)
    static let amber = UIColor(red: 1.00, green: 0.76, blue: 0.22, alpha: 1)
    static let violet = UIColor(red: 0.58, green: 0.44, blue: 1.00, alpha: 1)
    static let panel = UIColor.white.withAlphaComponent(0.10)
    static let panelStrong = UIColor.white.withAlphaComponent(0.16)

    static func color(for verdict: Verdict) -> UIColor {
        switch verdict {
        case .probablyTrue:
            return mint
        case .doubtful:
            return amber
        case .probablyFalse:
            return coral
        }
    }

    static func color(for answer: VerificationAnswer?) -> UIColor {
        switch answer {
        case .yes:
            return mint
        case .no:
            return coral
        case .notApplicable:
            return violet
        case .none:
            return UIColor.white.withAlphaComponent(0.45)
        }
    }

    static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = mint
    }
}

final class GradientBackgroundView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setup() {
        gradientLayer.colors = [
            UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.03, green: 0.20, blue: 0.18, alpha: 1).cgColor,
            UIColor(red: 0.28, green: 0.08, blue: 0.17, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

final class PanelView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = VerificDesign.panel
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.white.withAlphaComponent(0.14).cgColor
        layer.borderWidth = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func pinEdges(to guide: UILayoutGuide, inset: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: guide.topAnchor, constant: inset),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -inset)
        ])
    }

    func pinEdges(to view: UIView, inset: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
    }
}

extension UILabel {
    static func make(
        text: String? = nil,
        font: UIFont,
        color: UIColor = .white,
        lines: Int = 0
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = lines
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}

extension UIStackView {
    static func vertical(spacing: CGFloat = 12) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = spacing
        return stack
    }

    static func horizontal(spacing: CGFloat = 12) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = spacing
        stack.alignment = .center
        return stack
    }
}
