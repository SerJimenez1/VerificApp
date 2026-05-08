import XCTest
@testable import VerificApp

final class VerdictCalculatorTests: XCTestCase {
    func testFiveAffirmativeAnswersReturnsProbablyTrue() {
        let responses = makeResponses(yesCount: 5)

        let verdict = VerdictCalculator.calculate(from: responses)

        XCTAssertEqual(verdict, .probablyTrue)
    }

    func testThreeAffirmativeAnswersReturnsDoubtful() {
        let responses = makeResponses(yesCount: 3)

        let verdict = VerdictCalculator.calculate(from: responses)

        XCTAssertEqual(verdict, .doubtful)
    }

    func testTwoAffirmativeAnswersReturnsProbablyFalse() {
        let responses = makeResponses(yesCount: 2)

        let verdict = VerdictCalculator.calculate(from: responses)

        XCTAssertEqual(verdict, .probablyFalse)
    }

    func testNotApplicableDoesNotCountAsAffirmative() {
        var responses = makeResponses(yesCount: 4)
        responses[4].answer = .notApplicable
        responses[5].answer = .notApplicable

        let score = VerdictCalculator.credibilityScore(from: responses)
        let verdict = VerdictCalculator.calculate(from: responses)

        XCTAssertEqual(score, 4.0 / 6.0, accuracy: 0.001)
        XCTAssertEqual(verdict, .doubtful)
    }

    private func makeResponses(yesCount: Int) -> [CriterionResponse] {
        VerificationCriterion.all.enumerated().map { index, criterion in
            CriterionResponse(
                criterionID: criterion.id,
                answer: index < yesCount ? .yes : .no
            )
        }
    }
}
