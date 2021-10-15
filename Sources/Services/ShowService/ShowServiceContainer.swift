import ObjectLifetime
import API

public final class ShowServiceContainer {
    public lazy var trendingShowsUseCase = WeakFactory { TrendingShowsUseCase(repository: self.showRepository.value) }
    public lazy var searchQueryFilterUseCase = WeakFactory { SearchQueryFilterUseCase() }
    public lazy var searchShowUseCase = WeakFactory { SearchShowUseCase(repository: self.showRepository.value) }

    private lazy var showRepository = WeakFactory { ShowRepository(api: self.api.value) }

    private let api: WeakFactory<API>

    public init(api: WeakFactory<API>) {
        self.api = api
    }
}
