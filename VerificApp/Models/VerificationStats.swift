import Foundation

struct VerificationStats: Equatable {
    let total: Int
    let probablyTrue: Int
    let doubtful: Int
    let probablyFalse: Int

    static let empty = VerificationStats(total: 0, probablyTrue: 0, doubtful: 0, probablyFalse: 0)

    var riskyCount: Int {
        doubtful + probablyFalse
    }

    var riskyPercentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(riskyCount) / Double(total) * 100).rounded())
    }
}
