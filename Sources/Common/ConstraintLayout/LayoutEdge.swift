import UIKit

public enum LayoutEdge {
    case top(CGFloat)
    case bottom(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case left(CGFloat)
    case right(CGFloat)

    public static var top: LayoutEdge { .top(0) }
    public static var bottom: LayoutEdge { .bottom(0) }
    public static var leading: LayoutEdge { .leading(0) }
    public static var trailing: LayoutEdge { .trailing(0) }
    public static var left: LayoutEdge { .left(0) }
    public static var right: LayoutEdge { .right(0) }

    func constraint(_ source: Constrainable, to destination: Constrainable) -> NSLayoutConstraint {
        switch self {
        case .top(let inset):
            return source.topAnchor.constraint(equalTo: destination.topAnchor, constant: inset)
        case .bottom(let inset):
            return source.bottomAnchor.constraint(equalTo: destination.bottomAnchor, constant: -inset)
        case .leading(let inset):
            return source.leadingAnchor.constraint(equalTo: destination.leadingAnchor, constant: inset)
        case .trailing(let inset):
            return source.trailingAnchor.constraint(equalTo: destination.trailingAnchor, constant: -inset)
        case .left(let inset):
            return source.leftAnchor.constraint(equalTo: destination.leftAnchor, constant: inset)
        case .right(let inset):
            return source.rightAnchor.constraint(equalTo: destination.rightAnchor, constant: -inset)
        }
    }
}

extension Array where Element == LayoutEdge {
    public static var all: [LayoutEdge] { .all(0) }

    public static func all(_ inset: CGFloat) -> [LayoutEdge] {
        return [.top(inset), .bottom(inset), .left(inset), .right(inset)]
    }
}
