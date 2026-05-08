import UIKit

final class VerificationTableViewCell: UITableViewCell {
    static let reuseIdentifier = "VerificationTableViewCell"

    private let iconView = UIImageView()
    private let titleLabel = UILabel.make(font: .systemFont(ofSize: 17, weight: .bold), lines: 2)
    private let metaLabel = UILabel.make(font: .systemFont(ofSize: 12, weight: .medium), color: UIColor.white.withAlphaComponent(0.58), lines: 1)
    private let yesLabel = UILabel.make(font: .systemFont(ofSize: 12, weight: .bold), color: UIColor.white.withAlphaComponent(0.70), lines: 1)
    private var badge: BadgeLabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with record: VerificationRecord) {
        iconView.image = UIImage(systemName: record.verdict.symbolName)
        iconView.tintColor = VerificDesign.color(for: record.verdict)
        titleLabel.text = record.titleOrURL
        metaLabel.text = record.createdAt.formatted(date: .abbreviated, time: .shortened)
        yesLabel.text = "\(record.affirmativeCount)/6 sí"

        badge?.removeFromSuperview()
        let newBadge = BadgeLabel.verdict(record.verdict)
        badge = newBadge

        if let badgeContainer = contentView.viewWithTag(90) as? UIStackView {
            badgeContainer.insertArrangedSubview(newBadge, at: 0)
        }
    }

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.contentMode = .scaleAspectFit

        let textStack = UIStackView.vertical(spacing: 8)
        let badgeRow = UIStackView.horizontal(spacing: 8)
        badgeRow.tag = 90
        badgeRow.addArrangedSubview(yesLabel)
        badgeRow.addArrangedSubview(UIView())
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(badgeRow)
        textStack.addArrangedSubview(metaLabel)

        let row = UIStackView.horizontal(spacing: 12)
        row.translatesAutoresizingMaskIntoConstraints = false
        row.alignment = .top
        row.addArrangedSubview(iconView)
        row.addArrangedSubview(textStack)

        contentView.addSubview(row)
        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            row.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            row.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            row.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
