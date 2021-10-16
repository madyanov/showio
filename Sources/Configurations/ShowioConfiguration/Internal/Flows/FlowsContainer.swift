import DI
import RootFlow

final class FlowsContainer {
    lazy var rootFlowConfigurator = WeakFactory<RootFlowConfigurator> {
        let rootFlowScreenFactory = WeakFactory<RootFlow.RootFlowScreenFactory> {
            let showSearchScreenConfigurator = self.screens.showSearchScreenConfigurator.value
            let showDetailsScreenConfigurator = self.screens.showDetailsScreenConfigurator.value

            return RootFlowScreenFactory(showSearchScreenConfigurator: showSearchScreenConfigurator,
                                         showDetailsScreenConfigurator: showDetailsScreenConfigurator)
        }

        return RootFlowConfigurator(dependencies: .init(navigationController: self.common.navigationController,
                                                        featureFactory: rootFlowScreenFactory))
    }

    private let common: CommonContainer
    private let shared: SharedContainer
    private let services: ServicesContainer
    private let screens: ScreensContainer

    init(common: CommonContainer,
         shared: SharedContainer,
         services: ServicesContainer,
         screens: ScreensContainer) {

        self.common = common
        self.shared = shared
        self.services = services
        self.screens = screens
    }
}
