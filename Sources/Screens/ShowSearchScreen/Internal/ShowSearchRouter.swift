import ShowService

final class ShowSearchRouter {
    private let urlRouter: ShowSearchURLRouter
    private let showSelectHandler: (Show.ID) -> Void

    init(urlRouter: ShowSearchURLRouter,
         showSelectHandler: @escaping (Show.ID) -> Void) {

        self.urlRouter = urlRouter
        self.showSelectHandler = showSelectHandler
    }
}

extension ShowSearchRouter: ShowRouter {
    func selectShow(with id: Show.ID) {
        showSelectHandler(id)
    }

    func open(url urlString: String) {
        urlRouter.open(url: urlString)
    }
}
