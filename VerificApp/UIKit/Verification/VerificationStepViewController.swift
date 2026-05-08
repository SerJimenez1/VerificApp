import SwiftUI
import UIKit

final class VerificationStepViewController: UIViewController, UITextViewDelegate {
    private let store: VerificationStore
    private let viewModel: VerificationFlowViewModel

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView.vertical(spacing: 18)
    private let stepBadge = BadgeLabel(text: "Criterio 1 de 6", backgroundColor: VerificDesign.lime)
    private let percentLabel = UILabel.make(font: .systemFont(ofSize: 12, weight: .black), color: .white, lines: 1)
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let iconView = UIImageView()
    private let criterionTitle = UILabel.make(font: .systemFont(ofSize: 13, weight: .bold), color: VerificDesign.mint, lines: 1)
    private let criterionQuestion = UILabel.make(font: .systemFont(ofSize: 23, weight: .black), lines: 0)
    private let helperLabel = UILabel.make(font: .systemFont(ofSize: 15, weight: .medium), color: UIColor.white.withAlphaComponent(0.72), lines: 0)
    private let answerControl = UISegmentedControl(items: VerificationAnswer.allCases.map(\.label))
    private let noteTextView = PlaceholderTextView()
    private let backButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)

    init(store: VerificationStore, viewModel: VerificationFlowViewModel) {
        self.store = store
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Checklist"
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
        renderCurrentStep()
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
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])

        contentStack.addArrangedSubview(makeProgressPanel())
        contentStack.addArrangedSubview(makeQuestionPanel())
        contentStack.addArrangedSubview(makeAnswerPanel())
        contentStack.addArrangedSubview(makeNotePanel())
        contentStack.addArrangedSubview(makeNavigationRow())
    }

    private func makeProgressPanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 10)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let row = UIStackView.horizontal(spacing: 8)
        row.addArrangedSubview(stepBadge)
        row.addArrangedSubview(UIView())
        row.addArrangedSubview(percentLabel)

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = VerificDesign.mint
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.16)

        stack.addArrangedSubview(row)
        stack.addArrangedSubview(progressView)
        return panel
    }

    private func makeQuestionPanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 14)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let header = UIStackView.horizontal(spacing: 12)
        header.alignment = .top

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.tintColor = VerificDesign.lime
        iconView.contentMode = .scaleAspectFit
        iconView.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        iconView.layer.cornerRadius = 8
        iconView.layer.cornerCurve = .continuous

        let textStack = UIStackView.vertical(spacing: 6)
        textStack.addArrangedSubview(criterionTitle)
        textStack.addArrangedSubview(criterionQuestion)

        header.addArrangedSubview(iconView)
        header.addArrangedSubview(textStack)
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(helperLabel)

        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44)
        ])
        return panel
    }

    private func makeAnswerPanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 10)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let titleLabel = UILabel.make(text: "Respuesta", font: .systemFont(ofSize: 18, weight: .black), lines: 1)
        answerControl.translatesAutoresizingMaskIntoConstraints = false
        answerControl.selectedSegmentTintColor = VerificDesign.mint
        answerControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .normal)
        answerControl.setTitleTextAttributes([.foregroundColor: VerificDesign.ink, .font: UIFont.systemFont(ofSize: 14, weight: .black)], for: .selected)
        answerControl.addTarget(self, action: #selector(answerChanged), for: .valueChanged)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(answerControl)

        NSLayoutConstraint.activate([
            answerControl.heightAnchor.constraint(equalToConstant: 42)
        ])
        return panel
    }

    private func makeNotePanel() -> UIView {
        let panel = PanelView()
        let stack = UIStackView.vertical(spacing: 10)
        panel.addSubview(stack)
        stack.pinEdges(to: panel, inset: 16)

        let titleLabel = UILabel.make(text: "Nota personal", font: .systemFont(ofSize: 18, weight: .black), lines: 1)
        noteTextView.font = .systemFont(ofSize: 15, weight: .medium)
        noteTextView.placeholder = "Escribe qué revisaste, qué te hizo dudar o qué fuente usarías para contrastar."
        noteTextView.delegate = self

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(noteTextView)

        NSLayoutConstraint.activate([
            noteTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        return panel
    }

    private func makeNavigationRow() -> UIView {
        let row = UIStackView.horizontal(spacing: 12)
        row.distribution = .fillEqually

        configureSecondary(backButton, title: "Atrás", image: "chevron.left")
        configurePrimary(nextButton, title: "Siguiente", image: "chevron.right")
        backButton.addTarget(self, action: #selector(goBackStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(goNextStep), for: .touchUpInside)

        row.addArrangedSubview(backButton)
        row.addArrangedSubview(nextButton)
        return row
    }

    private func configurePrimary(_ button: UIButton, title: String, image: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: image)
        config.imagePadding = 8
        config.baseBackgroundColor = VerificDesign.mint
        config.baseForegroundColor = VerificDesign.ink
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12)
        button.configuration = config
    }

    private func configureSecondary(_ button: UIButton, title: String, image: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: image)
        config.imagePadding = 8
        config.baseBackgroundColor = UIColor.white.withAlphaComponent(0.14)
        config.baseForegroundColor = .white
        config.cornerStyle = .small
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 12, bottom: 14, trailing: 12)
        button.configuration = config
    }

    private func renderCurrentStep() {
        let criterion = viewModel.currentCriterion
        stepBadge.text = "Criterio \(viewModel.currentStepIndex + 1) de \(VerificationCriterion.all.count)"
        percentLabel.text = "\(Int(viewModel.progress * 100))%"
        progressView.setProgress(Float(viewModel.progress), animated: true)

        iconView.image = UIImage(systemName: criterion.iconName)
        criterionTitle.text = criterion.title
        criterionQuestion.text = criterion.question
        helperLabel.text = criterion.helper

        if let answer = viewModel.currentResponse.answer, let index = VerificationAnswer.allCases.firstIndex(of: answer) {
            answerControl.selectedSegmentIndex = index
        } else {
            answerControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }

        noteTextView.text = viewModel.currentResponse.note
        noteTextView.updatePlaceholder()

        backButton.isEnabled = viewModel.isFirstStep == false
        backButton.alpha = viewModel.isFirstStep ? 0.45 : 1
        updateNextButton()
    }

    private func updateNextButton() {
        let canMove = viewModel.canMoveForward
        nextButton.isEnabled = canMove
        nextButton.alpha = canMove ? 1 : 0.55

        let title = viewModel.isLastStep ? "Resultado" : "Siguiente"
        let image = viewModel.isLastStep ? "flag.checkered" : "chevron.right"
        configurePrimary(nextButton, title: title, image: image)
    }

    @objc private func answerChanged() {
        guard answerControl.selectedSegmentIndex >= 0 else { return }
        viewModel.responses[viewModel.currentStepIndex].answer = VerificationAnswer.allCases[answerControl.selectedSegmentIndex]
        updateNextButton()
    }

    func textViewDidChange(_ textView: UITextView) {
        noteTextView.updatePlaceholder()
        viewModel.responses[viewModel.currentStepIndex].note = textView.text
    }

    @objc private func goBackStep() {
        viewModel.moveBack()
        renderCurrentStep()
    }

    @objc private func goNextStep() {
        guard viewModel.canMoveForward else { return }
        viewModel.responses[viewModel.currentStepIndex].note = noteTextView.text

        if viewModel.isLastStep {
            let record = viewModel.makeRecord()
            store.add(record)
            let result = ResultView(record: record)
            let hosting = UIHostingController(rootView: result)
            hosting.title = "Resultado"
            hosting.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(hosting, animated: true)
        } else {
            viewModel.moveForward()
            renderCurrentStep()
        }
    }
}
