import UIKit

public enum LayoutAxis {
    case x(CGFloat)
    case y(CGFloat)

    public static var x: LayoutAxis { .x(0) }
    public static var y: LayoutAxis { .y(0) }

    func constraint(_ source: Constrainable, to destination: Constrainable) -> NSLayoutConstraint {
        switch self {
        case .x(let offset):
            return source.centerXAnchor.constraint(equalTo: destination.centerXAnchor, constant: offset)
        case .y(let offset):
            return source.centerYAnchor.constraint(equalTo: destination.centerYAnchor, constant: offset)
        }
    }
}

extension Array where Element == LayoutAxis {
    public static let all = Self.all(0)

    public static func all(_ offset: CGFloat) -> [LayoutAxis] {
        return [.x(offset), .y(offset)]
    }
}
