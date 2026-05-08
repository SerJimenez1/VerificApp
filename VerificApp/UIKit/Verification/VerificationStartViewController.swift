import UIKit

final class VerificationStartViewController: UIViewController, UITextViewDelegate {
    private let store: VerificationStore
    private let inputViewField = PlaceholderTextView()
    private let startButton = UIButton(type: .system)

    init(store: VerificationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        title = "Nueva verificación"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = GradientBackgroundView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        updateButtonState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputViewField.becomeFirstResponder()
    }

    private func setupLayout() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView.vertical(spacing: 18)

        view.addSubview(scroll)
        scroll.addSubview(stack)
        scroll.pinEdges(to: view.safeAreaLayoutGuide)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        let panel = PanelView()
        let panelStack = UIStackView.vertical(spacing: 14)
        panel.addSubview(panelStack)
        panelStack.pinEdges(to: panel, inset: 18)

        let badge = BadgeLabel(text: "Paso inicial", backgroundColor: VerificDesign.lime)
        let titleLabel = UILabel.make(text: "Pega el titular o URL sospechosa", font: .systemFont(ofSize: 30, weight: .black), lines: 0)
        let message = UILabel.make(
            text: "Evalúa señales clave y guarda tus notas para revisar el caso con calma.",
            font: .systemFont(ofSize: 16, weight: .medium),
            color: UIColor.white.withAlphaComponent(0.72),
            lines: 0
        )

        inputViewField.font = .systemFont(ofSize: 16, weight: .semibold)
        inputViewField.placeholder = "Ejemplo: “Candidato X anuncia fraude...”"
        inputViewField.delegate = self

        panelStack.alignment = .leading
        panelStack.addArrangedSubview(badge)
        panelStack.addArrangedSubview(titleLabel)
        panelStack.addArrangedSubview(message)
        panelStack.addArrangedSubview(inputViewField)

        NSLayoutConstraint.activate([
            inputViewField.heightAnchor.constraint(greaterThanOrEqualToConstant: 140),
            inputViewField.widthAnchor.constraint(equalTo: panelStack.widthAnchor)
        ])

        var config = UIButton.Configuration.filled()
        config.title = "Iniciar verificación"
        config.image = UIImage(systemName: "arrow.right.circle.fill")
        config.imagePadding = 10
        config.baseBackgroundColor = VerificDesign.mint
        config.baseForegroundColor = VerificDesign.ink
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 16, bottom: 15, trailing: 16)
        startButton.configuration = config
        startButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .black)
        startButton.addTarget(self, action: #selector(startChecklist), for: .touchUpInside)

        stack.addArrangedSubview(panel)
        stack.addArrangedSubview(startButton)
    }

    func textViewDidChange(_ textView: UITextView) {
        inputViewField.updatePlaceholder()
        updateButtonState()
    }

    private func updateButtonState() {
        let hasText = inputViewField.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        startButton.isEnabled = hasText
        startButton.alpha = hasText ? 1 : 0.55
    }

    @objc private func startChecklist() {
        let viewModel = VerificationFlowViewModel()
        viewModel.titleOrURL = inputViewField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.startChecklist()

        let controller = VerificationStepViewController(store: store, viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
