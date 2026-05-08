import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: VerificationStore
    @State private var selectedRecord: VerificationRecord?

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if store.sortedRecords.isEmpty {
                    VStack {
                        Spacer()
                        EmptyStateView(
                            title: "Sin historial todavía",
                            message: "Tus verificaciones guardadas aparecerán aquí con su veredicto y desglose.",
                            symbolName: "clock.badge.questionmark"
                        )
                        .padding(18)
                        Spacer()
                    }
                } else {
                    historyList
                }
            }
            .navigationTitle("Historial")
            .toolbarBackground(.hidden, for: .navigationBar)
            .sheet(item: $selectedRecord) { record in
                VerificationDetailView(record: record)
            }
        }
    }

    private var historyList: some View {
        let records = store.sortedRecords

        return List {
            ForEach(records) { record in
                Button {
                    selectedRecord = record
                } label: {
                    VerificationRow(record: record)
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
            }
            .onDelete { offsets in
                let targets = offsets.map { records[$0] }
                store.delete(records: targets)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .environmentObject(VerificationStore())
    }
}
