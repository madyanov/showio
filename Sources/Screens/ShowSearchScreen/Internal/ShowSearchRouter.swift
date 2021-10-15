final class ShowSearchRouter {
    private let urlRouter: ShowSearchURLRouter
    private let showSelectHandler: (Int) -> Void

    init(urlRouter: ShowSearchURLRouter,
         showSelectHandler: @escaping (Int) -> Void) {

        self.urlRouter = urlRouter
        self.showSelectHandler = showSelectHandler
    }
}

extension ShowSearchRouter: ShowRouter {
    func selectShow(with id: Int) {
        showSelectHandler(id)
    }

    func open(url urlString: String) {
        urlRouter.open(url: urlString)
    }
}
