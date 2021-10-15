import Foundation
import Promises

public final class API {
    public struct ImageSize {
        public static let poster = ImageSize("w300")
        public static let backdrop = ImageSize("w780")
        public static let still = ImageSize("w780")

        public let name: String

        private init(_ name: String) {
            self.name = name
        }
    }

    private let apiConfiguration: APIConfiguration
    private let languageCodeProvider: APILanguageCodeProvider
    private let urlSession: URLSession

    public init(configuration: APIConfiguration,
                languageCodeProvider: APILanguageCodeProvider,
                urlSession: URLSession = .shared) {

        self.apiConfiguration = configuration
        self.languageCodeProvider = languageCodeProvider
        self.urlSession = urlSession
    }

    public func configuration() -> Promise<ConfigurationResponse> {
        return request(path: "configuration")
    }

    public func search(query: String) -> Promise<TVSearchResponse> {
        return request(path: "search/tv", parameters: ["query": query])
    }

    public func trending() -> Promise<TVSearchResponse> {
        return request(path: "trending/tv/day")
    }

    public func tv(id: Int, seasons: [Int]) -> Promise<TVResponse> {
        let append = seasons
            .map { "season/\($0)" }
            .joined(separator: ",")

        return request(path: "tv/\(id)", parameters: ["append_to_response": append])
    }
}

private extension API {
    struct CodingKey: Swift.CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .custom { keys in
            let last = keys.last?.stringValue
                .lowercased()
                .replacingOccurrences(of: "(\\w)_(\\w)", with: "$1 $2", options: .regularExpression)
                .replacingOccurrences(of: "/", with: " ")
                .split(separator: " ")
                .enumerated()
                .map { $0.offset > 0 ? $0.element.capitalized : String($0.element) }
                .joined() ?? ""

            return CodingKey(stringValue: last)!
        }
    }

    func request<T: Decodable>(path: String, parameters: [String: String] = [:]) -> Promise<T> {
        guard let url = endpoint(path: path, parameters: parameters) else {
            return .failure(APIError.invalidEndpointURL)
        }

        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: apiConfiguration.timeout)

        return Promise { completion in
            self.urlSession
                .dataTask(with: request) { data, response, error in
                    if let error = error {
                        completion(.failure(APIError.network(error)))
                        return
                    }

                    if let httpURLResponse = response as? HTTPURLResponse,
                       !(200..<300).contains(httpURLResponse.statusCode) {

                        completion(.failure(APIError.http(status: httpURLResponse.statusCode)))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(APIError.invalidResponse))
                        return
                    }

                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = self.keyDecodingStrategy
                        completion(.success(try jsonDecoder.decode(T.self, from: data)))
                    } catch {
                        completion(.failure(APIError.format(error)))
                    }
                }
                .resume()
        }
    }

    func endpoint(path: String, parameters: [String: String] = [:]) -> URL? {
        guard let url = URL(string: apiConfiguration.endpoint)?.appendingPathComponent(path) else {
            return nil
        }

        var parameters = parameters
        parameters["api_key"] = parameters["api_key"] ?? apiConfiguration.apiKey
        parameters["language"] = parameters["language"] ?? languageCodeProvider.languageCode

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents?.url
    }
}
