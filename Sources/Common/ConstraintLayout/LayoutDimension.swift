import UIKit

public enum LayoutDimension {
    case width(CGFloat)
    case height(CGFloat)

    public static var width: LayoutDimension { .width(0) }
    public static var height: LayoutDimension { .height(0) }

    func constraint(_ source: Constrainable) -> NSLayoutConstraint {
        switch self {
        case .width(let width):
            return source.widthAnchor.constraint(equalToConstant: width)
        case .height(let height):
            return source.heightAnchor.constraint(equalToConstant: height)
        }
    }
}

extension Array where Element == LayoutDimension {
    public static func all(_ size: CGFloat) -> [LayoutDimension] {
        return [.width(size), .height(size)]
    }
}
