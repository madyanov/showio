import Promises

public final class SearchShowUseCase {
    private lazy var debouncedSearch = debounce(0.5) {
        self.repository.search(query: $0, limit: 30)
    }

    private let repository: ShowRepository

    init(repository: ShowRepository) {
        self.repository = repository
    }

    public func search(query: String?) -> Promise<[Show]> {
        guard let query = query, query.isEmpty == false else {
            return .nothing
        }

        return debouncedSearch(query)
    }
}
