import UIKit
import DI

public struct RootFlowDependencies {
    let navigationController: WeakFactory<UINavigationController>
    let featureFactory: WeakFactory<RootFlowScreenFactory>

    public init(navigationController: WeakFactory<UINavigationController>,
                featureFactory: WeakFactory<RootFlowScreenFactory>) {

        self.navigationController = navigationController
        self.featureFactory = featureFactory
    }
}
