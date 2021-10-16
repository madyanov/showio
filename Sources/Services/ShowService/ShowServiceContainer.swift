import DI
import API

public final class ShowServiceContainer {
    public lazy var trendingShowsUseCase = WeakLazy { TrendingShowsUseCase(repository: self.showRepository.value) }
    public lazy var searchQueryFilterUseCase = WeakLazy { SearchQueryFilterUseCase() }
    public lazy var searchShowUseCase = WeakLazy { SearchShowUseCase(repository: self.showRepository.value) }

    private lazy var showRepository = WeakLazy { ShowRepository(api: self.api.value) }

    private let api: WeakLazy<API>

    public init(api: WeakLazy<API>) {
        self.api = api
    }
}
