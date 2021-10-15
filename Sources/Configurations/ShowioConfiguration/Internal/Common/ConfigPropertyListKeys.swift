import PropertyLists

struct ConfigPropertyListTag { }
typealias ConfigPropertyListKey<Value> = PropertyListKey<ConfigPropertyListTag, Value>

extension PropertyListKeys {
    static let configTheMovieDBAPIKey = ConfigPropertyListKey<String>("TMDB API Key")
    static let configSupportEmail = ConfigPropertyListKey<String>("Support Email")
    static let configPrivacyPolicyURL = ConfigPropertyListKey<String>("Privacy Policy URL")
}
