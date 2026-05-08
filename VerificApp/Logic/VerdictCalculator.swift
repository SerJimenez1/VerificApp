import Foundation

struct VerdictCalculator {
    static let expectedCriteriaCount = 6

    static func calculate(from responses: [CriterionResponse]) -> Verdict {
        let yesCount = affirmativeCount(in: responses)

        switch yesCount {
        case 5...:
            return .probablyTrue
        case 3...4:
            return .doubtful
        default:
            return .probablyFalse
        }
    }

    static func credibilityScore(from responses: [CriterionResponse]) -> Double {
        let denominator = max(expectedCriteriaCount, responses.count)
        guard denominator > 0 else { return 0 }
        return Double(affirmativeCount(in: responses)) / Double(denominator)
    }

    static func affirmativeCount(in responses: [CriterionResponse]) -> Int {
        responses.filter { $0.answer == .yes }.count
    }
}
