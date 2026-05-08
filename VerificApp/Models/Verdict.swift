import Foundation

enum Verdict: String, Codable, CaseIterable, Identifiable {
    case probablyTrue
    case doubtful
    case probablyFalse

    var id: String { rawValue }

    var title: String {
        switch self {
        case .probablyTrue:
            return "Probablemente verdadero"
        case .doubtful:
            return "Dudoso"
        case .probablyFalse:
            return "Probablemente falso"
        }
    }

    var shortTitle: String {
        switch self {
        case .probablyTrue:
            return "Verdadero"
        case .doubtful:
            return "Dudoso"
        case .probablyFalse:
            return "Falso"
        }
    }

    var symbolName: String {
        switch self {
        case .probablyTrue:
            return "checkmark.seal.fill"
        case .doubtful:
            return "questionmark.diamond.fill"
        case .probablyFalse:
            return "xmark.octagon.fill"
        }
    }

    var guidance: String {
        switch self {
        case .probablyTrue:
            return "La mayoría de criterios tiene señales positivas. Aun así, conserva tus notas antes de compartir."
        case .doubtful:
            return "Hay señales mezcladas. Conviene contrastar con fuentes oficiales o más de un medio confiable."
        case .probablyFalse:
            return "Pocas señales sostienen la noticia. Lo más responsable es no difundirla hasta verificar mejor."
        }
    }
}
