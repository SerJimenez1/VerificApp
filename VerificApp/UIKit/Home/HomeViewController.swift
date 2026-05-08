import UIKit

final class HomeViewController: UIViewController {
    private let store: VerificationStore
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView.vertical(spacing: 18)
    private let totalValue = UILabel.make(font: .systemFont(ofSize: 30, weight: .black), color: .white, lines: 1)
    private let doubtfulValue = UILabel.make(font: .systemFont(ofSize: 30, weight: .black), color: .white, lines: 1)
    private let falseValue = UILabel.make(font: .systemFont(ofSize: 30, weight: .black), color: .white, lines: 1)
    private let riskyValue = UILabel.make(font: .systemFont(ofSize: 30, weight: .black), color: .white, lines: 1)
    private let insightTitle = UILabel.make(font: .systemFont(ofSize: 18, weight: .black), color: .white, lines: 0)
    private let insightMessage = UILabel.make(font: .systemFont(ofSize: 15, weight: .medium), color: UIColor.white.withAlphaComponent(0.72), lines: 0)

    init(store: VerificationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "VerificApp"
        tabBarItem.title = "Inicio"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = GradientBackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 18),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -18),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28)
        ])

        contentStack.addArrangedSubview(makeHero())
        contentStack.addArrangedSubview(makeNewVerificationButton())
        contentStack.addArrangedSubview(makeStatsSection())
        contentStack.addArrangedSubview(makeInsightPanel())
        contentStack.addArrangedSubview(makeCriteriaPanel())
    }

    private func makeHero() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 12)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 18)

        let badge = BadgeLabel(text: "JNE companion", backgroundColor: VerificDesign.lime)
        let titleLabel = UILabel.make(text: "Verifica antes de creer", font: .systemFont(ofSize: 38, weight: .black), lines: 0)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.76

        let subtitle = UILabel.make(
            text: "Checklist rápido para titulares, URLs, imágenes y audios sospechosos durante las Elecciones 2026.",
            font: .systemFont(ofSize: 16, weight: .medium),
            color: UIColor.white.withAlphaComponent(0.76),
            lines: 0
        )

        stack.addArrangedSubview(badge)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitle)
        stack.alignment = .leading
        return panel
    }

    private func makeNewVerificationButton() -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Nueva verificación"
        configuration.subtitle = "Pega un titular o URL y responde 6 criterios."
        configuration.image = UIImage(systemName: "plus.magnifyingglass")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 12
        configuration.baseBackgroundColor = VerificDesign.panelStrong
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .small
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        button.layer.borderColor = VerificDesign.mint.withAlphaComponent(0.45).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(startVerification), for: .touchUpInside)
        return button
    }

    private func makeStatsSection() -> UIView {
        let section = UIStackView.vertical(spacing: 12)
        let titleLabel = UILabel.make(text: "Tus estadísticas", font: .systemFont(ofSize: 22, weight: .black), lines: 1)
        section.addArrangedSubview(titleLabel)

        let firstRow = UIStackView.horizontal(spacing: 12)
        firstRow.distribution = .fillEqually
        firstRow.addArrangedSubview(makeStatTile(title: "Noticias verificadas", valueLabel: totalValue, icon: "doc.text.magnifyingglass", color: VerificDesign.mint))
        firstRow.addArrangedSubview(makeStatTile(title: "Dudosas", valueLabel: doubtfulValue, icon: "questionmark.circle.fill", color: VerificDesign.amber))

        let secondRow = UIStackView.horizontal(spacing: 12)
        secondRow.distribution = .fillEqually
        secondRow.addArrangedSubview(makeStatTile(title: "Probablemente falsas", valueLabel: falseValue, icon: "xmark.octagon.fill", color: VerificDesign.coral))
        secondRow.addArrangedSubview(makeStatTile(title: "Con riesgo", valueLabel: riskyValue, icon: "chart.pie.fill", color: VerificDesign.violet))

        section.addArrangedSubview(firstRow)
        section.addArrangedSubview(secondRow)
        return section
    }

    private func makeStatTile(title: String, valueLabel: UILabel, icon: String, color: UIColor) -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 8)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 14)

        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = color
        imageView.contentMode = .scaleAspectFit

        let titleLabel = UILabel.make(text: title, font: .systemFont(ofSize: 12, weight: .semibold), color: UIColor.white.withAlphaComponent(0.72), lines: 2)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 26),
            imageView.heightAnchor.constraint(equalToConstant: 26),
            panel.heightAnchor.constraint(greaterThanOrEqualToConstant: 132)
        ])

        stack.alignment = .leading
        return panel
    }

    private func makeInsightPanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.horizontal(spacing: 12)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)
        stack.alignment = .top

        let imageView = UIImageView(image: UIImage(systemName: "bolt.heart.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = VerificDesign.amber
        imageView.contentMode = .scaleAspectFit

        let textStack = UIStackView.vertical(spacing: 6)
        textStack.addArrangedSubview(insightTitle)
        textStack.addArrangedSubview(insightMessage)

        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(textStack)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 32),
            imageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        return panel
    }

    private func makeCriteriaPanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 12)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let titleLabel = UILabel.make(text: "Checklist base", font: .systemFont(ofSize: 22, weight: .black), lines: 1)
        stack.addArrangedSubview(titleLabel)

        VerificationCriterion.all.forEach { criterion in
            let row = UIStackView.horizontal(spacing: 12)
            let icon = UIImageView(image: UIImage(systemName: criterion.iconName))
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.tintColor = VerificDesign.lime
            icon.contentMode = .scaleAspectFit

            let label = UILabel.make(text: criterion.title, font: .systemFont(ofSize: 15, weight: .semibold), lines: 1)
            row.addArrangedSubview(icon)
            row.addArrangedSubview(label)
            row.addArrangedSubview(UIView())
            stack.addArrangedSubview(row)

            NSLayoutConstraint.activate([
                icon.widthAnchor.constraint(equalToConstant: 26),
                icon.heightAnchor.constraint(equalToConstant: 26)
            ])
        }

        return panel
    }

    private func updateStats() {
        let stats = store.stats
        totalValue.text = "\(stats.total)"
        doubtfulValue.text = "\(stats.doubtful)"
        falseValue.text = "\(stats.probablyFalse)"
        riskyValue.text = "\(stats.riskyPercentage)%"

        if stats.total == 0 {
            insightTitle.text = "Tu radar está limpio"
            insightMessage.text = "Cuando guardes verificaciones, aquí verás cuántas terminaron como dudosas o probablemente falsas."
        } else if stats.riskyPercentage >= 50 {
            insightTitle.text = "Patrón de riesgo: \(stats.riskyPercentage)%"
            insightMessage.text = "Más de la mitad de tus verificaciones tienen señales de riesgo. Buen trabajo frenando contenido antes de compartirlo."
        } else {
            insightTitle.text = "Patrón de riesgo: \(stats.riskyPercentage)%"
            insightMessage.text = "La mayoría de tus verificaciones tiene señales positivas. Sigue revisando fuente, fecha y lenguaje antes de confiar."
        }
    }

    @objc private func startVerification() {
        let controller = VerificationStartViewController(store: store)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}
