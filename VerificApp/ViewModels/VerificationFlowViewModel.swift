import Combine
import Foundation

final class VerificationFlowViewModel: ObservableObject {
    @Published var titleOrURL = ""
    @Published var responses: [CriterionResponse]
    @Published var currentStepIndex = 0
    @Published var hasStartedChecklist = false

    init() {
        responses = VerificationCriterion.all.map { CriterionResponse(criterionID: $0.id) }
    }

    var canStart: Bool {
        titleOrURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
    }

    var currentCriterion: VerificationCriterion {
        VerificationCriterion.all[currentStepIndex]
    }

    var currentResponse: CriterionResponse {
        responses[currentStepIndex]
    }

    var canMoveForward: Bool {
        responses[currentStepIndex].answer != nil
    }

    var isFirstStep: Bool {
        currentStepIndex == 0
    }

    var isLastStep: Bool {
        currentStepIndex == VerificationCriterion.all.count - 1
    }

    var progress: Double {
        Double(currentStepIndex + 1) / Double(VerificationCriterion.all.count)
    }

    func startChecklist() {
        guard canStart else { return }
        hasStartedChecklist = true
    }

    func moveBack() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
    }

    func moveForward() {
        guard canMoveForward, isLastStep == false else { return }
        currentStepIndex += 1
    }

    func makeRecord() -> VerificationRecord {
        let cleanedTitle = titleOrURL.trimmingCharacters(in: .whitespacesAndNewlines)
        let verdict = VerdictCalculator.calculate(from: responses)
        let score = VerdictCalculator.credibilityScore(from: responses)

        return VerificationRecord(
            titleOrURL: cleanedTitle,
            responses: responses,
            verdict: verdict,
            credibilityScore: score
        )
    }
}
