import ObjectLifetime
import ShowSearchScreen
import ShowDetailsScreen

final class ScreensContainer {
    lazy var showSearchScreenConfigurator = WeakFactory<ShowSearchScreenConfigurator> {
        let urlRouter = WeakFactory { self.common.urlRouter.value as ShowSearchURLRouter }

        let trendingShowsUseCase = self.services.showService.trendingShowsUseCase
        let searchQueryFilterUseCase = self.services.showService.searchQueryFilterUseCase
        let searchShowUseCase = self.services.showService.searchShowUseCase

        let dependencies = ShowSearchScreenDependencies(urlRouter: urlRouter,
                                                        trendingShowsUseCase: trendingShowsUseCase,
                                                        searchQueryFilterUseCase: searchQueryFilterUseCase,
                                                        searchShowUseCase: searchShowUseCase)

        return ShowSearchScreenConfigurator(dependencies: dependencies)
    }

    lazy var showDetailsScreenConfigurator = WeakFactory {
        ShowDetailsScreenConfigurator(dependencies: .init())
    }

    private let common: CommonContainer
    private let shared: SharedContainer
    private let services: ServicesContainer

    init(common: CommonContainer, shared: SharedContainer, services: ServicesContainer) {
        self.common = common
        self.shared = shared
        self.services = services
    }
}
