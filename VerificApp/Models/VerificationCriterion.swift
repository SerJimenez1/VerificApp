import Foundation

enum CriterionID: String, Codable, CaseIterable, Identifiable {
    case originalSource
    case sourceHistory
    case corroboration
    case recentDate
    case realImage
    case neutralLanguage

    var id: String { rawValue }
}

struct VerificationCriterion: Identifiable, Hashable {
    let id: CriterionID
    let title: String
    let question: String
    let helper: String
    let iconName: String

    static let all: [VerificationCriterion] = [
        VerificationCriterion(
            id: .originalSource,
            title: "Fuente original",
            question: "¿Identifica la fuente original?",
            helper: "Busca si la noticia muestra quién publicó primero la información y si enlaza documentos, declaraciones o datos verificables.",
            iconName: "person.text.rectangle"
        ),
        VerificationCriterion(
            id: .sourceHistory,
            title: "Historial confiable",
            question: "¿La fuente tiene historial confiable?",
            helper: "Revisa si el medio o la cuenta corrige errores, firma sus notas y evita difundir rumores sin sustento.",
            iconName: "checkmark.seal"
        ),
        VerificationCriterion(
            id: .corroboration,
            title: "Otras fuentes",
            question: "¿Hay otras fuentes que lo confirman?",
            helper: "Contrasta con medios reconocidos, comunicados oficiales o especialistas citados con nombre y cargo.",
            iconName: "link"
        ),
        VerificationCriterion(
            id: .recentDate,
            title: "Fecha reciente",
            question: "¿La fecha es reciente?",
            helper: "Verifica si el contenido corresponde al proceso electoral actual y no a una noticia antigua reciclada.",
            iconName: "calendar.badge.clock"
        ),
        VerificationCriterion(
            id: .realImage,
            title: "Imagen real",
            question: "¿La imagen parece real o verificable?",
            helper: "Si usa foto, video o captura, anota si podrías comprobarla con búsqueda inversa o si muestra señales de edición.",
            iconName: "photo.on.rectangle.angled"
        ),
        VerificationCriterion(
            id: .neutralLanguage,
            title: "Lenguaje neutral",
            question: "¿El lenguaje es neutral y no sensacionalista?",
            helper: "Observa si usa insultos, urgencia exagerada, mayúsculas o frases diseñadas para activar miedo o rabia.",
            iconName: "text.bubble"
        )
    ]

    static func definition(for id: CriterionID) -> VerificationCriterion {
        all.first { $0.id == id } ?? all[0]
    }
}
