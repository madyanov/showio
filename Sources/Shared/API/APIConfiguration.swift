import Foundation

public struct APIConfiguration {
    let endpoint: String
    let timeout: TimeInterval
    let apiKey: String

    public init(endpoint: String,
                timeout: TimeInterval,
                apiKey: String) {

        self.endpoint = endpoint
        self.timeout = timeout
        self.apiKey = apiKey
    }
}
