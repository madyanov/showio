import Foundation
import ObjectLifetime
import PropertyLists
import Styling
import API

final class SharedContainer {
    lazy var config = try! PropertyList<ConfigPropertyListTag>(name: "Config", bundle: Bundle.module)

    lazy var api = WeakFactory {
        API(configuration: .init(endpoint: "https://api.themoviedb.org/3/",
                                 timeout: 60,
                                 apiKey: self.config[.configTheMovieDBAPIKey]!),
            languageCodeProvider: self.common.languageCodeProvider.value)
    }

    private let common: CommonContainer

    init(common: CommonContainer) {
        self.common = common

        DefaultThemeProvider.shared.changeThemeAccording(common.navigationController.value.traitCollection)
    }
}
