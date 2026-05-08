import Foundation

enum VerificationAnswer: String, Codable, CaseIterable, Identifiable {
    case yes
    case no
    case notApplicable

    var id: String { rawValue }

    var label: String {
        switch self {
        case .yes:
            return "Sí"
        case .no:
            return "No"
        case .notApplicable:
            return "N/A"
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .yes:
            return "Sí"
        case .no:
            return "No"
        case .notApplicable:
            return "No aplica"
        }
    }
}
