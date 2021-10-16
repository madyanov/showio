import UIKit

public protocol ViewShader {
    var viewWithShadow: UIView? { get }

    func addShadow()
    func removeShadow()
}

extension ViewShader {
    public func addShadow() {
        guard let view = viewWithShadow else { return }

        view.layer.shadowRadius = .standardSpacing * 2
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.3
        view.layer.masksToBounds = false

        view.layer.shadowPath = UIBezierPath(roundedRect: view.layer.bounds,
                                             byRoundingCorners: [.topLeft, .topRight],
                                             cornerRadii: CGSize(width: 30, height: 30)).cgPath
    }

    public func removeRoundedCornersAndShadow() {
        guard let view = viewWithShadow else { return }

        view.layer.shadowRadius = 0
        view.layer.masksToBounds = true
    }
}
