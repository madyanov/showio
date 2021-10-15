import UIKit

extension NSLayoutConstraint {
    public class func activate(_ constraints: [NSLayoutConstraint], priority: UILayoutPriority) {
        constraints.forEach { $0.priority = priority }
        NSLayoutConstraint.activate(constraints)
    }
}
