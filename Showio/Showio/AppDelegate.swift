import UIKit
import ShowioConfiguration

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let configurator = ShowioConfigurator()
        let rootFlowCoordinator = configurator.configure()

        window = UIWindow()
        window?.rootViewController = rootFlowCoordinator.rootViewController
        window?.makeKeyAndVisible()

        rootFlowCoordinator.start()

        return true
    }
}
