import RootFlow

public final class ShowioConfigurator {
    public init() { }

    public func configure() -> RootFlowCoordinator {
        let common = CommonContainer()
        let shared = SharedContainer(common: common)
        let screens = ScreensContainer(common: common, shared: shared)
        let flows = FlowsContainer(common: common, shared: shared, screens: screens)

        return flows.rootFlowConfigurator.value.configure()
    }
}
