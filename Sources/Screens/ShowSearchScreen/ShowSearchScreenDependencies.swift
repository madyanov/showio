import DI
import ShowService

public struct ShowSearchScreenDependencies {
    let urlRouter: WeakLazy<ShowSearchURLRouter>

    let trendingShowsUseCase: WeakLazy<TrendingShowsUseCase>
    let searchQueryFilterUseCase: WeakLazy<SearchQueryFilterUseCase>
    let searchShowUseCase: WeakLazy<SearchShowUseCase>

    public init(urlRouter: WeakLazy<ShowSearchURLRouter>,
                trendingShowsUseCase: WeakLazy<TrendingShowsUseCase>,
                searchQueryFilterUseCase: WeakLazy<SearchQueryFilterUseCase>,
                searchShowUseCase: WeakLazy<SearchShowUseCase>) {

        self.urlRouter = urlRouter
        self.trendingShowsUseCase = trendingShowsUseCase
        self.searchQueryFilterUseCase = searchQueryFilterUseCase
        self.searchShowUseCase = searchShowUseCase
    }
}
