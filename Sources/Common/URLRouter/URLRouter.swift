import UIKit

public final class URLRouter {
    public init() { }

    public func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    public func open(url urlString: String) {
        guard let url = URL(string: urlString) else { return }
        open(url)
    }
}
