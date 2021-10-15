public enum APIError: Error {
    case invalidEndpointURL
    case network(Error)
    case http(status: Int)
    case invalidResponse
    case format(Error)
}
