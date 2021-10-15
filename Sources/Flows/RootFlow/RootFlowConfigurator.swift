public final class RootFlowConfigurator {
    private let dependencies: RootFlowDependencies

    public init(dependencies: RootFlowDependencies) {
        self.dependencies = dependencies
    }

    public func configure() -> RootFlowCoordinator {
        return RootFlowCoordinator(navigationController: dependencies.navigationController.value,
                                   featureFactory: dependencies.featureFactory.value)
    }
}
