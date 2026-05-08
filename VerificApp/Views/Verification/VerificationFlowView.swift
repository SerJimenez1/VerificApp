import SwiftUI

struct VerificationFlowView: View {
    @EnvironmentObject private var store: VerificationStore
    @StateObject private var viewModel = VerificationFlowViewModel()
    @State private var resultRecord: VerificationRecord?
    @State private var showResult = false
    @FocusState private var titleFieldFocused: Bool

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    if viewModel.hasStartedChecklist {
                        checklistStep
                    } else {
                        titleInput
                    }
                }
                .padding(18)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Nueva verificación")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .onAppear {
            titleFieldFocused = true
        }
        .navigationDestination(isPresented: $showResult) {
            if let resultRecord {
                ResultView(record: resultRecord)
            }
        }
    }

    private var titleInput: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 10) {
                Label("Paso inicial", systemImage: "doc.text.magnifyingglass")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppPalette.lime)

                Text("Pega el titular o URL sospechosa")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Evalúa señales clave y guarda tus notas para revisar el caso con calma.")
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }

            TextField("Ejemplo: “Candidato X anuncia fraude...”", text: $viewModel.titleOrURL, axis: .vertical)
                .focused($titleFieldFocused)
                .textInputAutocapitalization(.sentences)
                .autocorrectionDisabled()
                .lineLimit(3...6)
                .font(.body.weight(.semibold))
                .padding(14)
                .foregroundStyle(.white)
                .background(Color.black.opacity(0.22), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                }

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                    viewModel.startChecklist()
                    titleFieldFocused = false
                }
            } label: {
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                    Text("Iniciar verificación")
                    Spacer()
                    Text("6 pasos")
                        .font(.caption.weight(.black))
                        .foregroundStyle(AppPalette.ink)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(AppPalette.lime, in: Capsule())
                }
                .font(.headline.weight(.black))
                .foregroundStyle(AppPalette.ink)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(viewModel.canStart ? AppPalette.mint : Color.white.opacity(0.35), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(viewModel.canStart == false)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .verificPanel()
    }

    private var checklistStep: some View {
        let answerBinding = Binding<VerificationAnswer?>(
            get: { viewModel.responses[viewModel.currentStepIndex].answer },
            set: { viewModel.responses[viewModel.currentStepIndex].answer = $0 }
        )

        let noteBinding = Binding<String>(
            get: { viewModel.responses[viewModel.currentStepIndex].note },
            set: { viewModel.responses[viewModel.currentStepIndex].note = $0 }
        )

        return VStack(alignment: .leading, spacing: 18) {
            progressHeader

            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: viewModel.currentCriterion.iconName)
                        .font(.title2.weight(.black))
                        .foregroundStyle(AppPalette.lime)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.currentCriterion.title)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppPalette.mint)

                        Text(viewModel.currentCriterion.question)
                            .font(.title2.weight(.black))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Text(viewModel.currentCriterion.helper)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(Color.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .verificPanel()

            AnswerPicker(selection: answerBinding)

            NoteEditor(text: noteBinding)

            navigationControls
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Criterio \(viewModel.currentStepIndex + 1) de \(VerificationCriterion.all.count)")
                    .font(.caption.weight(.black))
                    .foregroundStyle(AppPalette.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(AppPalette.lime, in: Capsule())

                Spacer()

                Text("\(Int(viewModel.progress * 100))%")
                    .font(.caption.weight(.black))
                    .foregroundStyle(.white)
            }

            ProgressView(value: viewModel.progress)
                .tint(AppPalette.mint)
                .frame(minHeight: 10)
        }
        .verificPanel()
    }

    private var navigationControls: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                    viewModel.moveBack()
                }
            } label: {
                Label("Atrás", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryActionButtonStyle())
            .disabled(viewModel.isFirstStep)
            .opacity(viewModel.isFirstStep ? 0.45 : 1)

            Button {
                handlePrimaryAction()
            } label: {
                Label(viewModel.isLastStep ? "Resultado" : "Siguiente", systemImage: viewModel.isLastStep ? "flag.checkered" : "chevron.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryActionButtonStyle())
            .disabled(viewModel.canMoveForward == false)
            .opacity(viewModel.canMoveForward ? 1 : 0.55)
        }
    }

    private func handlePrimaryAction() {
        guard viewModel.canMoveForward else { return }

        if viewModel.isLastStep {
            let record = viewModel.makeRecord()
            store.add(record)
            resultRecord = record
            showResult = true
        } else {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                viewModel.moveForward()
            }
        }
    }
}

struct AnswerPicker: View {
    @Binding var selection: VerificationAnswer?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Respuesta")
                .font(.headline.weight(.black))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                ForEach(VerificationAnswer.allCases) { answer in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.82)) {
                            selection = answer
                        }
                    } label: {
                        Text(answer.label)
                            .font(.headline.weight(.black))
                            .foregroundStyle(selection == answer ? AppPalette.ink : .white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(
                                selection == answer ? AppPalette.color(for: answer) : Color.white.opacity(0.10),
                                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.white.opacity(selection == answer ? 0 : 0.12), lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(answer.accessibilityLabel)
                }
            }
        }
        .verificPanel()
    }
}

struct NoteEditor: View {
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Nota personal")
                .font(.headline.weight(.black))
                .foregroundStyle(.white)

            ZStack(alignment: .topLeading) {
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Escribe qué revisaste, qué te hizo dudar o qué fuente usarías para contrastar.")
                        .font(.callout)
                        .foregroundStyle(Color.white.opacity(0.46))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 10)
                }

                TextEditor(text: $text)
                    .font(.callout.weight(.medium))
                    .foregroundStyle(.white)
                    .frame(minHeight: 112)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .padding(8)
            .background(Color.black.opacity(0.20), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .verificPanel()
    }
}

struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(AppPalette.ink)
            .padding(.vertical, 14)
            .background(AppPalette.mint.opacity(configuration.isPressed ? 0.78 : 1), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.black))
            .foregroundStyle(.white)
            .padding(.vertical, 14)
            .background(Color.white.opacity(configuration.isPressed ? 0.08 : 0.14), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color.white.opacity(0.16), lineWidth: 1)
            }
    }
}

struct VerificationFlowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerificationFlowView()
                .environmentObject(VerificationStore())
        }
    }
}
