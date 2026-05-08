import Foundation

struct CriterionResponse: Identifiable, Codable, Hashable {
    let criterionID: CriterionID
    var answer: VerificationAnswer?
    var note: String

    var id: CriterionID { criterionID }

    init(criterionID: CriterionID, answer: VerificationAnswer? = nil, note: String = "") {
        self.criterionID = criterionID
        self.answer = answer
        self.note = note
    }
}
