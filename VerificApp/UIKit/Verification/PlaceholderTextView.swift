import UIKit

final class PlaceholderTextView: UITextView {
    private let placeholderLabel = UILabel()

    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    override var text: String! {
        didSet {
            updatePlaceholder()
        }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updatePlaceholder() {
        placeholderLabel.isHidden = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.22)
        textColor = .white
        tintColor = VerificDesign.mint
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.white.withAlphaComponent(0.16).cgColor
        layer.borderWidth = 1
        textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.46)
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)

        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])
    }
}
