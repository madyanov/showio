import UIKit
import ShowService

public final class ShowSearchScreenConfigurator {
    private let dependencies: ShowSearchScreenDependencies

    public init(dependencies: ShowSearchScreenDependencies) {
        self.dependencies = dependencies
    }

    public func configure(showSelectHandler: @escaping (Show.ID) -> Void) -> UIViewController {
        let router = ShowSearchRouter(urlRouter: dependencies.urlRouter.value,
                                      showSelectHandler: showSelectHandler)
        let dataSource = ShowSearchDataSource()

        let presenter = ShowSearchPresenter(router: router,
                                            dataSource: dataSource,
                                            searchShowUseCase: dependencies.searchShowUseCase.value,
                                            trendingShowsUseCase: dependencies.trendingShowsUseCase.value,
                                            searchQueryFilterUseCase: dependencies.searchQueryFilterUseCase.value)

        return ShowSearchViewController(presenter: presenter, dataSource: dataSource)
    }
}
