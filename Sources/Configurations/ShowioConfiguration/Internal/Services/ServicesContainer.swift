import ObjectLifetime
import ShowService

final class ServicesContainer {
    lazy var showService = { ShowServiceContainer(api: self.shared.api) }()

    private let common: CommonContainer
    private let shared: SharedContainer

    init(common: CommonContainer, shared: SharedContainer) {
        self.common = common
        self.shared = shared
    }
}
