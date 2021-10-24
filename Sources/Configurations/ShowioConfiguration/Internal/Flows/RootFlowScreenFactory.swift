import UIKit
import ShowSearchScreen
import ShowDetailsScreen
import RootFlow
import ShowService

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
    func makeShowSearchScreen(showSelectHandler: @escaping (Show.ID) -> Void) -> UIViewController {
        return showSearchScreenConfigurator.configure(showSelectHandler: showSelectHandler)
    }

    func makeShowDetailsScreen() -> UIViewController {
        return showDetailsScreenConfigurator.configure()
    }
}
