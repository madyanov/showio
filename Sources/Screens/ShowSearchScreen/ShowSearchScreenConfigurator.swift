import UIKit
import API
import ShowService

public final class ShowSearchScreenConfigurator {
    private let dependencies: ShowSearchScreenDependencies

    public init(dependencies: ShowSearchScreenDependencies) {
        self.dependencies = dependencies
    }

    public func configure(showSelectHandler: @escaping (Int) -> Void) -> UIViewController {
        let showRepository = ShowRepository(api: dependencies.api.value)
        let searchShowUseCase = SearchShowUseCase(repository: showRepository)
        let trendingShowsUseCase = TrendingShowsUseCase(repository: showRepository)
        let searchQueryFilterUseCase = SearchQueryFilterUseCase()

        let router = ShowSearchRouter(urlRouter: dependencies.urlRouter.value,
                                      showSelectHandler: showSelectHandler)
        let dataSource = ShowSearchDataSource()

        let presenter = ShowSearchPresenter(router: router,
                                            dataSource: dataSource,
                                            searchShowUseCase: searchShowUseCase,
                                            trendingShowsUseCase: trendingShowsUseCase,
                                            searchQueryFilterUseCase: searchQueryFilterUseCase)

        return ShowSearchViewController(presenter: presenter, dataSource: dataSource)
    }
}
