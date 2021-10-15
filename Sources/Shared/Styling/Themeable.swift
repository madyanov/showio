import UIKit

public protocol Themeable: AnyObject {
    func apply(theme: Theme)
}

extension Themeable where Self: UITraitEnvironment {
    public var themeProvider: ThemeProvider { DefaultThemeProvider.shared }
}
