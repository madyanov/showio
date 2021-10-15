import UIKit
import API

public final class ShowDetailsScreenConfigurator {
    private let dependencies: ShowDetailsScreenDependencies

    public init(dependencies: ShowDetailsScreenDependencies) {
        self.dependencies = dependencies
    }

    public func configure() -> UIViewController {
        return ShowDetailsViewController()
    }
}
