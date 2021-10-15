import API

public struct ShowDetailsScreenDependencies {
    let api: API

    public init(api: API) {
        self.api = api
    }
}
