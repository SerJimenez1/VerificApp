import SwiftUI

struct VerificationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let record: VerificationRecord

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        header
                        responseBreakdown
                    }
                    .padding(18)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Detalle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            VerdictBadge(verdict: record.verdict)

            Text(record.titleOrURL)
                .font(.title2.weight(.black))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 10) {
                Label("\(record.affirmativeCount)/6 sí", systemImage: "checklist.checked")
                Label(record.createdAt.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.white.opacity(0.70))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .verificPanel()
    }

    private var responseBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Criterios respondidos")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            ForEach(VerificationCriterion.all) { criterion in
                let response = record.responses.first { $0.criterionID == criterion.id }
                CriterionSummaryRow(criterion: criterion, response: response)
            }
        }
    }
}

struct CriterionSummaryRow: View {
    let criterion: VerificationCriterion
    let response: CriterionResponse?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: criterion.iconName)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppPalette.lime)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(criterion.question)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(criterion.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.58))
                }

                Spacer()

                AnswerBadge(answer: response?.answer)
            }

            if let note = response?.note, note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                Text(note)
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .verificPanel()
    }
}
