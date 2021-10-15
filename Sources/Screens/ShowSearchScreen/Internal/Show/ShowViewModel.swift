import Foundation
import ShowCollectionScene
import ShowService

final class ShowViewModel {
    let name: String
    let firstAirDateYear: String?
    let posterURL: URL?

    let isDummy = false
    let progress: Float = 0
    let numberOfNewEpisodes = 0
    let canDelete = false

    private let show: Show
    private let router: ShowRouter

    init(show: Show, router: ShowRouter) {
        name = show.name
        firstAirDateYear = show.firstAirDate?.year
        posterURL = show.posterURL

        self.show = show
        self.router = router
    }
}

extension ShowViewModel: ShowCollectionScene.ShowViewModel {
    func tap() {
        router.selectShow(with: show.id)
    }

    func delete() { }
}

private extension Date {
    var year: String { "\(Calendar.current.component(.year, from: self))" }
}
