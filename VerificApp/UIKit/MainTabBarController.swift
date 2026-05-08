import UIKit

final class MainTabBarController: UITabBarController {
    private let store: VerificationStore

    init(store: VerificationStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        VerificDesign.configureNavigationBar()
        setupTabs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTabs() {
        let home = HomeViewController(store: store)
        let homeNav = UINavigationController(rootViewController: home)
        homeNav.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house.fill"), tag: 0)

        let history = HistoryListViewController(store: store)
        let historyNav = UINavigationController(rootViewController: history)
        historyNav.tabBarItem = UITabBarItem(title: "Historial", image: UIImage(systemName: "clock.arrow.circlepath"), tag: 1)

        viewControllers = [homeNav, historyNav]

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.04, green: 0.05, blue: 0.08, alpha: 0.96)
        appearance.stackedLayoutAppearance.selected.iconColor = VerificDesign.mint
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: VerificDesign.mint]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.58)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.58)]
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
