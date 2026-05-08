import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private let store = VerificationStore()
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = MainTabBarController(store: store)
        window.tintColor = VerificDesign.mint
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
