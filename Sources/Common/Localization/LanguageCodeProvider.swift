import Foundation

public final class LanguageCodeProvider {
    public var languageCode: String {
        Locale.preferredLanguages.first ?? Locale.current.languageCode ?? defaultLanguageCode
    }

    private let defaultLanguageCode: String

    public init(defaultLanguageCode: String = "en") {
        self.defaultLanguageCode = defaultLanguageCode
    }
}
