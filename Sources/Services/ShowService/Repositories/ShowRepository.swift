import Foundation
import Promises
import API

public final class ShowRepository {
    private var cachedConfiguration: ConfigurationResponse?
    private var cachedTrendingShows: [Show]?

    private let api: API

    public init(api: API) {
        self.api = api
    }

    func search(query: String, limit: Int) -> Promise<[Show]> {
        return configuration()
            .then { self.shows(from: self.api.search(query: query), configuration: $0) }
            .map { Array($0.prefix(limit)) }
    }

    func trending(limit: Int) -> Promise<[Show]> {
        if let trendingShows = cachedTrendingShows {
            return .success(trendingShows)
        }

        return configuration()
            .then { self.shows(from: self.api.trending(), configuration: $0) }
            .map { Array($0.prefix(limit)) }
            .continue { self.cachedTrendingShows = $0 }
    }
}

private extension ShowRepository {
    func configuration() -> Promise<ConfigurationResponse> {
        if let configuration = cachedConfiguration {
            return .success(configuration)
        }

        return api.configuration()
            .continue { self.cachedConfiguration = $0 }
    }

    func shows(from promise: Promise<TVSearchResponse>, configuration: ConfigurationResponse) -> Promise<[Show]> {
        return promise.map {
            ($0.results ?? []).compactMap { self.show(from: $0, configuration: configuration) }
        }
    }

    func show(from tv: TVResponse, configuration: ConfigurationResponse) -> Show? {
        guard let id = tv.id, let name = tv.name else { return nil }

        return Show(id: id,
                    name: name,
                    firstAirDate: tv.firstAirDate?.date(),
                    posterURL: imageURL(for: tv.posterPath, size: .poster, configuration: configuration))
    }

    func imageURL(for path: String?,
                  size: API.ImageSize,
                  configuration: ConfigurationResponse) -> URL? {

        guard let path = path, !path.isEmpty else { return nil }
        return URL(string: configuration.images.secureBaseUrl + size.name + path)
    }
}

private extension String {
    func date(with format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
