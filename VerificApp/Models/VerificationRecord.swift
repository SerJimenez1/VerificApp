import Foundation

struct VerificationRecord: Identifiable, Codable, Hashable {
    let id: UUID
    var titleOrURL: String
    var createdAt: Date
    var responses: [CriterionResponse]
    var verdict: Verdict
    var credibilityScore: Double

    init(
        id: UUID = UUID(),
        titleOrURL: String,
        createdAt: Date = Date(),
        responses: [CriterionResponse],
        verdict: Verdict,
        credibilityScore: Double
    ) {
        self.id = id
        self.titleOrURL = titleOrURL
        self.createdAt = createdAt
        self.responses = responses
        self.verdict = verdict
        self.credibilityScore = credibilityScore
    }

    var affirmativeCount: Int {
        responses.filter { $0.answer == .yes }.count
    }
}
