import Promises
import ShowCollectionScene
import ShowService

final class ShowSearchPresenter {
    private weak var ui: ShowSearchUI?

    private var lastQuery: String?
    private let searchDisposeBox = DisposeBox()

    private let router: ShowSearchRouter
    private let dataSource: ShowSearchDataSource
    private let searchShowUseCase: SearchShowUseCase
    private let trendingShowsUseCase: TrendingShowsUseCase
    private let searchQueryFilterUseCase: SearchQueryFilterUseCase

    init(router: ShowSearchRouter,
         dataSource: ShowSearchDataSource,
         searchShowUseCase: SearchShowUseCase,
         trendingShowsUseCase: TrendingShowsUseCase,
         searchQueryFilterUseCase: SearchQueryFilterUseCase) {

        self.router = router
        self.dataSource = dataSource
        self.searchShowUseCase = searchShowUseCase
        self.trendingShowsUseCase = trendingShowsUseCase
        self.searchQueryFilterUseCase = searchQueryFilterUseCase
    }

    func didLoad(ui: ShowSearchUI) {
        self.ui = ui

        ui.searchQueryUpdateHandler = { [weak self] query in
            self?.search(query: query)
        }

        ui.poweredByLinkTapHandler = { [weak self] in
            self?.router.open(url: "https://www.themoviedb.org/")
        }
    }
}

private extension ShowSearchPresenter {
    func search(query: String?) {
        let query = searchQueryFilterUseCase.filter(query: query)

        guard query != lastQuery else { return }
        lastQuery = query

        reload(with: [])
        ui?.startActivityIndicator()

        searchShowUseCase.search(query: query)
            .recover { self.trendingShowsUseCase.trending() }
            .always { self.ui?.stopActivityIndicator() }
            .done { self.reload(with: $0) }
            .execute()
            .disposed(by: searchDisposeBox)
    }

    func reload(with shows: [Show]) {
        dataSource.shows = showViewModels(from: shows)
        ui?.reload()
    }

    func showViewModels(from shows: [Show]) -> [ShowViewModel] {
        return shows.map { ShowViewModel(show: $0, router: router) }
    }
}
