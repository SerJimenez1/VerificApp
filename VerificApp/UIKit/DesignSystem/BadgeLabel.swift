import UIKit

final class BadgeLabel: UILabel {
    init(text: String, backgroundColor: UIColor, textColor: UIColor = VerificDesign.ink) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        font = .systemFont(ofSize: 12, weight: .black)
        textAlignment = .center
        layer.cornerRadius = 13
        layer.masksToBounds = true
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let original = super.intrinsicContentSize
        return CGSize(width: original.width + 20, height: max(26, original.height + 10))
    }

    static func verdict(_ verdict: Verdict) -> BadgeLabel {
        BadgeLabel(text: verdict.shortTitle, backgroundColor: VerificDesign.color(for: verdict))
    }

    static func answer(_ answer: VerificationAnswer?) -> BadgeLabel {
        BadgeLabel(text: answer?.label ?? "Sin responder", backgroundColor: VerificDesign.color(for: answer), textColor: answer == nil ? .white : VerificDesign.ink)
    }
}
