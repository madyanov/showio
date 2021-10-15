import UIKit

public protocol ViewCornersRounder {
    var viewWithRoundedCorners: UIView? { get }

    func roundCorners()
    func removeRoundedCorners()
}

extension ViewCornersRounder {
    public func roundCorners() {
        guard let view = viewWithRoundedCorners else { return }

        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
    }

    public func removeRoundedCorners() {
        guard let view = viewWithRoundedCorners else { return }

        view.layer.cornerRadius = 0
        view.layer.masksToBounds = false
    }
}
