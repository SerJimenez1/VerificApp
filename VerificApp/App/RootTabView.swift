import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }

            HistoryView()
                .tabItem {
                    Label("Historial", systemImage: "clock.arrow.circlepath")
                }
        }
    }
}
