public struct ConfigurationResponse: Decodable {
    public struct Images: Decodable {
        public let secureBaseUrl: String
    }

    public let images: Images
}
