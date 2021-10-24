import ShowService

protocol ShowRouter {
    func selectShow(with id: Show.ID)
}
