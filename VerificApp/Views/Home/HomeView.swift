import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: VerificationStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        hero
                        newVerificationLink
                        statsSection
                        insightSection
                        criteriaPreview
                    }
                    .padding(18)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("VerificApp")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("JNE companion", systemImage: "checkmark.shield.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppPalette.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(AppPalette.lime, in: Capsule())

                Spacer()

                Image(systemName: "sparkles")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppPalette.amber)
            }

            Text("Verifica antes de creer")
                .font(.system(size: 38, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.78)

            Text("Un checklist rápido para titulares, URLs, imágenes y audios sospechosos durante las Elecciones 2026.")
                .font(.callout.weight(.medium))
                .foregroundStyle(Color.white.opacity(0.76))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .verificPanel(padding: 18)
    }

    private var newVerificationLink: some View {
        NavigationLink {
            VerificationFlowView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.title2.weight(.black))
                    .frame(width: 46, height: 46)
                    .foregroundStyle(AppPalette.ink)
                    .background(AppPalette.mint, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Nueva verificación")
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)

                    Text("Pega un titular o URL y responde 6 criterios.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.70))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(Color.white.opacity(0.70))
            }
            .padding(16)
            .background(AppPalette.panelStrong, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(AppPalette.mint.opacity(0.45), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tus estadísticas")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            LazyVGrid(columns: columns, spacing: 12) {
                StatTile(title: "Noticias verificadas", value: "\(store.stats.total)", symbolName: "doc.text.magnifyingglass", color: AppPalette.mint)
                StatTile(title: "Dudosas", value: "\(store.stats.doubtful)", symbolName: "questionmark.circle.fill", color: AppPalette.amber)
                StatTile(title: "Probablemente falsas", value: "\(store.stats.probablyFalse)", symbolName: "xmark.octagon.fill", color: AppPalette.coral)
                StatTile(title: "Con riesgo", value: "\(store.stats.riskyPercentage)%", symbolName: "chart.pie.fill", color: AppPalette.violet)
            }
        }
    }

    private var insightSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "bolt.heart.fill")
                .font(.title2.weight(.bold))
                .foregroundStyle(AppPalette.amber)
                .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 6) {
                Text(insightTitle)
                    .font(.headline.weight(.black))
                    .foregroundStyle(.white)

                Text(insightMessage)
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .verificPanel()
    }

    private var criteriaPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Checklist base")
                .font(.title3.weight(.black))
                .foregroundStyle(.white)

            ForEach(VerificationCriterion.all) { criterion in
                HStack(spacing: 12) {
                    Image(systemName: criterion.iconName)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppPalette.lime)
                        .frame(width: 28)

                    Text(criterion.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.vertical, 6)
            }
        }
        .verificPanel()
    }

    private var insightTitle: String {
        store.stats.total == 0 ? "Tu radar está limpio" : "Patrón de riesgo: \(store.stats.riskyPercentage)%"
    }

    private var insightMessage: String {
        if store.stats.total == 0 {
            return "Cuando guardes verificaciones, aquí verás cuántas terminaron como dudosas o probablemente falsas."
        }

        if store.stats.riskyPercentage >= 50 {
            return "Más de la mitad de tus verificaciones tienen señales de riesgo. Buena señal: estás frenando contenido antes de compartirlo."
        }

        return "La mayoría de tus verificaciones recientes tiene señales positivas. Sigue revisando fuente, fecha y lenguaje antes de confiar."
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(VerificationStore())
    }
}
