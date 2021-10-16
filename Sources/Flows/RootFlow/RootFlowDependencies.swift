import UIKit
import DI

public struct RootFlowDependencies {
    let navigationController: WeakLazy<UINavigationController>
    let featureFactory: WeakLazy<RootFlowScreenFactory>

    public init(navigationController: WeakLazy<UINavigationController>,
                featureFactory: WeakLazy<RootFlowScreenFactory>) {

        self.navigationController = navigationController
        self.featureFactory = featureFactory
    }
}
