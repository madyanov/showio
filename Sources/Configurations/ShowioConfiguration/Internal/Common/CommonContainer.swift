import UIKit
import ObjectLifetime
import Localization
import URLRouter

final class CommonContainer {
    lazy var navigationController = WeakFactory<UINavigationController> { DefaultNavigationController() }
    lazy var languageCodeProvider = WeakFactory { LanguageCodeProvider() }
    lazy var urlRouter = WeakFactory { URLRouter() }
}
