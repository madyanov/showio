import UIKit
import DI
import Localization
import URLRouter

final class CommonContainer {
    lazy var navigationController = WeakLazy<UINavigationController> { DefaultNavigationController() }
    lazy var languageCodeProvider = WeakLazy { LanguageCodeProvider() }
    lazy var urlRouter = WeakLazy { URLRouter() }
}
