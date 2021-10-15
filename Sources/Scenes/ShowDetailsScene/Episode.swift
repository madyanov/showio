import Foundation

public struct Episode {
    public struct Show {
        let backdropURL: URL?
        let posterURL: URL?

        public init(backdropURL: URL?, posterURL: URL?) {
            self.backdropURL = backdropURL
            self.posterURL = posterURL
        }
    }

    let seasonNumber: Int
    let number: Int
    let name: String
    let isViewed: Bool
    let localizedAirDate: String?

    var show: Show
    var stillURL: URL?
    var overview: String

    public init(seasonNumber: Int,
                number: Int,
                name: String,
                isViewed: Bool,
                localizedAirDate: String?,
                show: Show,
                stillURL: URL?,
                overview: String) {

        self.seasonNumber = seasonNumber
        self.number = number
        self.name = name
        self.isViewed = isViewed
        self.localizedAirDate = localizedAirDate
        self.show = show
        self.stillURL = stillURL
        self.overview = overview
    }
}
