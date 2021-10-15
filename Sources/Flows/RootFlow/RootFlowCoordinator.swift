import UIKit

public struct RootFlowCoordinator {
    public var rootViewController: UIViewController { navigationController }

    private let navigationController: UINavigationController
    private let featureFactory: RootFlowScreenFactory

    init(navigationController: UINavigationController,
         featureFactory: RootFlowScreenFactory) {

        self.navigationController = navigationController
        self.featureFactory = featureFactory
    }

    public func start() {
        let showSearchViewController = featureFactory.makeShowSearchScreen { showDetails(id: $0) }
        navigationController.viewControllers = [showSearchViewController]
    }
}

private extension RootFlowCoordinator {
    func showDetails(id: Int) {
        let showDetailsViewController = featureFactory.makeShowDetailsScreen()
        navigationController.present(showDetailsViewController, animated: true)
    }
}
