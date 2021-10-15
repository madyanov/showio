import UIKit

public protocol ThemeProvider {
    var theme: Theme { get }

    func register(_ themeable: Themeable)
    func reload(_ themeable: Themeable)
    func changeThemeAccording(_ traitCollection: UITraitCollection)
}
