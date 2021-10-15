import ObjectLifetime
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

    private var common: CommonContainer
    private var shared: SharedContainer
    private var screens: ScreensContainer

    init(common: CommonContainer, shared: SharedContainer, screens: ScreensContainer) {
        self.common = common
        self.shared = shared
        self.screens = screens
    }
}
