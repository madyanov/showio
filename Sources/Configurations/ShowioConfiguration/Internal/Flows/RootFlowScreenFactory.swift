import UIKit
import ShowSearchScreen
import ShowDetailsScreen
import RootFlow

final class RootFlowScreenFactory {
    private let showSearchScreenConfigurator: ShowSearchScreenConfigurator
    private let showDetailsScreenConfigurator: ShowDetailsScreenConfigurator

    init(showSearchScreenConfigurator: ShowSearchScreenConfigurator,
         showDetailsScreenConfigurator: ShowDetailsScreenConfigurator) {

        self.showSearchScreenConfigurator = showSearchScreenConfigurator
        self.showDetailsScreenConfigurator = showDetailsScreenConfigurator
    }
}

extension RootFlowScreenFactory: RootFlow.RootFlowScreenFactory {
    func makeShowSearchScreen(showSelectHandler: @escaping (Int) -> Void) -> UIViewController {
        return showSearchScreenConfigurator.configure(showSelectHandler: showSelectHandler)
    }

    func makeShowDetailsScreen() -> UIViewController {
        return showDetailsScreenConfigurator.configure()
    }
}
