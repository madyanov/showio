import RootFlow

public final class ShowioConfigurator {
    public init() { }

    public func configure() -> RootFlowCoordinator {
        let common = CommonContainer()
        let shared = SharedContainer(common: common)
        let services = ServicesContainer(common: common, shared: shared)
        let screens = ScreensContainer(common: common, shared: shared, services: services)
        let flows = FlowsContainer(common: common, shared: shared, services: services, screens: screens)

        return flows.rootFlowConfigurator.value.configure()
    }
}
