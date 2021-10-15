import Foundation

extension String {
    public func localized(comment: String, _ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: comment),
                      locale: .current,
                      arguments: arguments)
    }
}
