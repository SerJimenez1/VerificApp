import SwiftUI

struct ResultView: View {
    let record: VerificationRecord
    @State private var animatedScore = 0.0

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    resultHero
                    scorePanel
                    guidancePanel
                    responseBreakdown
                }
                .padding(18)
                .padding(.bottom, 28)
            }
        }
        .navigationTitle("Resultado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            animatedScore = 0
            withAnimation(.easeOut(duration: 1.0)) {
                animatedScore = record.credibilityScore
            }
        }
    }

    private var resultHero: some View {
        VStack(alignment: .leading, spacing: 14) {
            VerdictBadge(verdict: record.verdict)

            Text(record.verdict.title)
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.76)

            Text(record.titleOrURL)
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .verificPanel()
    }

    private var scorePanel: some View {
        VStack(spacing: 18) {
            Gauge(value: animatedScore, in: 0...1) {
                Text("Credibilidad")
            } currentValueLabel: {
                Text("\(Int(animatedScore * 100))%")
                    .font(.headline.weight(.black))
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(AppPalette.color(for: record.verdict))
            .scaleEffect(2.1)
            .frame(height: 150)

            VStack(spacing: 6) {
                Text("Nivel de credibilidad")
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)

                Text("\(record.affirmativeCount) respuestas afirmativas de 6 criterios")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.70))
            }

            ProgressView(value: animatedScore)
                .tint(AppPalette.color(for: record.verdict))
        }
        .frame(maxWidth: .infinity)
        .verificPanel(padding: 22)
    }

    private var guidancePanel: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.max.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(AppPalette.amber)
                .frame(width: 36)

            Text(record.verdict.guidance)
                .font(.callout.weight(.medium))
                .foregroundStyle(Color.white.opacity(0.76))
                .fixedSize(horizontal: false, vertical: true)
        }
        .verificPanel()
    }

    private var responseBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Desglose")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            ForEach(VerificationCriterion.all) { criterion in
                let response = record.responses.first { $0.criterionID == criterion.id }
                CriterionSummaryRow(criterion: criterion, response: response)
            }
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResultView(
                record: VerificationRecord(
                    titleOrURL: "Encuesta viral afirma que un candidato ganó por 80%",
                    responses: VerificationCriterion.all.enumerated().map { index, criterion in
                        CriterionResponse(criterionID: criterion.id, answer: index < 4 ? .yes : .no, note: index == 2 ? "Confirmé en dos fuentes adicionales." : "")
                    },
                    verdict: .doubtful,
                    credibilityScore: 0.66
                )
            )
        }
    }
}
