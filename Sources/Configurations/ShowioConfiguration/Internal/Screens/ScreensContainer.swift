import ObjectLifetime
import ShowSearchScreen
import ShowDetailsScreen

final class ScreensContainer {
    lazy var showSearchScreenConfigurator = WeakFactory<ShowSearchScreenConfigurator> {
        let urlRouter = WeakFactory { self.common.urlRouter.value as ShowSearchURLRouter }
        return ShowSearchScreenConfigurator(dependencies: .init(api: self.shared.api, urlRouter: urlRouter))
    }

    lazy var showDetailsScreenConfigurator = WeakFactory {
        ShowDetailsScreenConfigurator(dependencies: .init(api: self.shared.api.value))
    }

    private var common: CommonContainer
    private var shared: SharedContainer

    init(common: CommonContainer, shared: SharedContainer) {
        self.common = common
        self.shared = shared
    }
}
