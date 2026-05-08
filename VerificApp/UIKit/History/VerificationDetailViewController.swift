import UIKit

final class VerificationDetailViewController: UIViewController {
    private let record: VerificationRecord
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView.vertical(spacing: 14)

    init(record: VerificationRecord) {
        self.record = record
        super.init(nibName: nil, bundle: nil)
        title = "Detalle"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = GradientBackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cerrar", style: .done, target: self, action: #selector(close))
        setupLayout()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        contentStack.addArrangedSubview(makeHeader())
        VerificationCriterion.all.forEach { criterion in
            let response = record.responses.first { $0.criterionID == criterion.id }
            contentStack.addArrangedSubview(makeCriterionPanel(criterion: criterion, response: response))
        }
    }

    private func makeHeader() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 12)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)
        stack.alignment = .leading

        let titleLabel = UILabel.make(text: record.titleOrURL, font: .systemFont(ofSize: 24, weight: .black), lines: 0)
        let meta = UILabel.make(
            text: "\(record.affirmativeCount)/6 sí • \(record.createdAt.formatted(date: .abbreviated, time: .shortened))",
            font: .systemFont(ofSize: 13, weight: .semibold),
            color: UIColor.white.withAlphaComponent(0.70),
            lines: 0
        )

        stack.addArrangedSubview(BadgeLabel.verdict(record.verdict))
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(meta)
        return panel
    }

    private func makeCriterionPanel(criterion: VerificationCriterion, response: CriterionResponse?) -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 10)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let row = UIStackView.horizontal(spacing: 10)
        row.alignment = .top

        let icon = UIImageView(image: UIImage(systemName: criterion.iconName))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = VerificDesign.lime
        icon.contentMode = .scaleAspectFit

        let question = UILabel.make(text: criterion.question, font: .systemFont(ofSize: 16, weight: .bold), lines: 0)
        row.addArrangedSubview(icon)
        row.addArrangedSubview(question)
        row.addArrangedSubview(BadgeLabel.answer(response?.answer))

        stack.addArrangedSubview(row)

        if let note = response?.note.trimmingCharacters(in: .whitespacesAndNewlines), note.isEmpty == false {
            let noteLabel = UILabel.make(text: note, font: .systemFont(ofSize: 14, weight: .medium), color: UIColor.white.withAlphaComponent(0.72), lines: 0)
            stack.addArrangedSubview(noteLabel)
        }

        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 26),
            icon.heightAnchor.constraint(equalToConstant: 26)
        ])
        return panel
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}
