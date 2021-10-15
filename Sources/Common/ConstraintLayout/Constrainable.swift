import UIKit

public protocol Constrainable {
    var `super`: Constrainable? { get }
    var safeArea: Constrainable { get }

    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    func prepareForLayout()
}

extension UIView: Constrainable {
    public var `super`: Constrainable? { superview }
    public var safeArea: Constrainable { safeAreaLayoutGuide }

    public func prepareForLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILayoutGuide: Constrainable {
    public var `super`: Constrainable? { owningView }
    public var safeArea: Constrainable { `super`?.safeArea ?? UILayoutGuide() }

    public func prepareForLayout() { }
}
