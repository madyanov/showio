import ObjectLifetime
import API

public struct ShowSearchScreenDependencies {
    let api: WeakFactory<API>
    let urlRouter: WeakFactory<ShowSearchURLRouter>

    public init(api: WeakFactory<API>, urlRouter: WeakFactory<ShowSearchURLRouter>) {
        self.api = api
        self.urlRouter = urlRouter
    }
}
