import UIKit

public final class DefaultThemeProvider {
    public static let shared = DefaultThemeProvider()

    public var theme: Theme = .dark {
        didSet {
            guard theme != oldValue else { return }
            notifyObservers()
        }
    }

    private var observers = NSHashTable<AnyObject>.weakObjects()

    private init() { }
}

extension DefaultThemeProvider: ThemeProvider {
    public func register(_ themeable: Themeable) {
        themeable.apply(theme: theme)
        observers.add(themeable)
    }

    public func reload(_ themeable: Themeable) {
        themeable.apply(theme: theme)
    }

    public func changeThemeAccording(_ traitCollection: UITraitCollection) {
        if #available(iOS 13, *) {
            theme = traitCollection.userInterfaceStyle == .light ? .light : .dark
        }
    }
}

private extension DefaultThemeProvider {
    func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap { $0 as? Themeable }
                .forEach { $0.apply(theme: self.theme) }
        }
    }
}
