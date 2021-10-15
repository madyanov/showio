import Promises

public final class TrendingShowsUseCase {
    private let repository: ShowRepository

    public init(repository: ShowRepository) {
        self.repository = repository
    }

    public func trending() -> Promise<[Show]> {
        return repository.trending(limit: 30)
    }
}
