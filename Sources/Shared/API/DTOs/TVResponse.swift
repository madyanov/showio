public struct TVResponse: Decodable {
    public struct GenreResponse: Decodable {
        public let id: Int?
        public let name: String?
    }

    public struct NetworkResponse: Decodable {
        public let name: String?
    }

    public struct EpisodeResponse: Decodable {
        public let id: Int?
        public let seasonNumber: Int?
        public let episodeNumber: Int?
        public let name: String?
        public let airDate: String?
        public let overview: String?
        public let stillPath: String?
    }

    public struct SeasonResponse: Decodable {
        public let id: Int?
        public let seasonNumber: Int?
        public let name: String?
        public let airDate: String?
        public let overview: String?
        public let posterPath: String?
        public let episodeCount: Int?
        public let episodes: [EpisodeResponse]?
    }

    public let id: Int?
    public let originalName: String?
    public let name: String?
    public let overview: String?
    public let posterPath: String?
    public let backdropPath: String?
    public let firstAirDate: String?
    public let popularity: Double?
    public let voteCount: Int?
    public let voteAverage: Double?
    public let episodeRunTime: [Int]?
    public let inProduction: Bool?
    public let numberOfSeasons: Int?
    public let numberOfEpisodes: Int?
    public let lastAirDate: String?
    public let originCountry: [String]?
    public let nextEpisodeToAir: EpisodeResponse?
    public let networks: [NetworkResponse]?
    public let genres: [GenreResponse]?
    public let seasons: [SeasonResponse]?

    public var fullSeasons: [SeasonResponse] {
        let mirror = Mirror(reflecting: self)

        return mirror.children.compactMap { property, value in
            guard property?.hasPrefix("season") ?? false else { return nil }
            return value as? SeasonResponse
        }
    }

    // workaround to get all episodes >_<
    private let season1: SeasonResponse?, season2: SeasonResponse?, season3: SeasonResponse?, season4: SeasonResponse?, season5: SeasonResponse?
    private let season6: SeasonResponse?, season7: SeasonResponse?, season8: SeasonResponse?, season9: SeasonResponse?, season10: SeasonResponse?
    private let season11: SeasonResponse?, season12: SeasonResponse?, season13: SeasonResponse?, season14: SeasonResponse?, season15: SeasonResponse?
    private let season16: SeasonResponse?, season17: SeasonResponse?, season18: SeasonResponse?, season19: SeasonResponse?, season20: SeasonResponse?
    private let season21: SeasonResponse?, season22: SeasonResponse?, season23: SeasonResponse?, season24: SeasonResponse?, season25: SeasonResponse?
    private let season26: SeasonResponse?, season27: SeasonResponse?, season28: SeasonResponse?, season29: SeasonResponse?, season30: SeasonResponse?
    private let season31: SeasonResponse?, season32: SeasonResponse?, season33: SeasonResponse?, season34: SeasonResponse?, season35: SeasonResponse?
    private let season36: SeasonResponse?, season37: SeasonResponse?, season38: SeasonResponse?, season39: SeasonResponse?, season40: SeasonResponse?
    private let season41: SeasonResponse?, season42: SeasonResponse?, season43: SeasonResponse?, season44: SeasonResponse?, season45: SeasonResponse?
    private let season46: SeasonResponse?, season47: SeasonResponse?, season48: SeasonResponse?, season49: SeasonResponse?, season50: SeasonResponse?
    private let season51: SeasonResponse?, season52: SeasonResponse?, season53: SeasonResponse?, season54: SeasonResponse?, season55: SeasonResponse?
    private let season56: SeasonResponse?, season57: SeasonResponse?, season58: SeasonResponse?, season59: SeasonResponse?, season60: SeasonResponse?
    private let season61: SeasonResponse?, season62: SeasonResponse?, season63: SeasonResponse?, season64: SeasonResponse?, season65: SeasonResponse?
    private let season66: SeasonResponse?, season67: SeasonResponse?, season68: SeasonResponse?, season69: SeasonResponse?, season70: SeasonResponse?
    private let season71: SeasonResponse?, season72: SeasonResponse?, season73: SeasonResponse?, season74: SeasonResponse?, season75: SeasonResponse?
    private let season76: SeasonResponse?, season77: SeasonResponse?, season78: SeasonResponse?, season79: SeasonResponse?, season80: SeasonResponse?
    private let season81: SeasonResponse?, season82: SeasonResponse?, season83: SeasonResponse?, season84: SeasonResponse?, season85: SeasonResponse?
    private let season86: SeasonResponse?, season87: SeasonResponse?, season88: SeasonResponse?, season89: SeasonResponse?, season90: SeasonResponse?
    private let season91: SeasonResponse?, season92: SeasonResponse?, season93: SeasonResponse?, season94: SeasonResponse?, season95: SeasonResponse?
    private let season96: SeasonResponse?, season97: SeasonResponse?, season98: SeasonResponse?, season99: SeasonResponse?, season100: SeasonResponse?
}
