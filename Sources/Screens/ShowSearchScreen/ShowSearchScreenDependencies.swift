import DI
import ShowService

public struct ShowSearchScreenDependencies {
    let urlRouter: WeakFactory<ShowSearchURLRouter>

    let trendingShowsUseCase: WeakFactory<TrendingShowsUseCase>
    let searchQueryFilterUseCase: WeakFactory<SearchQueryFilterUseCase>
    let searchShowUseCase: WeakFactory<SearchShowUseCase>

    public init(urlRouter: WeakFactory<ShowSearchURLRouter>,
                trendingShowsUseCase: WeakFactory<TrendingShowsUseCase>,
                searchQueryFilterUseCase: WeakFactory<SearchQueryFilterUseCase>,
                searchShowUseCase: WeakFactory<SearchShowUseCase>) {

        self.urlRouter = urlRouter
        self.trendingShowsUseCase = trendingShowsUseCase
        self.searchQueryFilterUseCase = searchQueryFilterUseCase
        self.searchShowUseCase = searchShowUseCase
    }
}
