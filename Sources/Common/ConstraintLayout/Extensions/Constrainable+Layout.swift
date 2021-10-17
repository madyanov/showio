import UIKit

extension Constrainable {
    @discardableResult
    public func pin(edges: [LayoutEdge] = .all,
                    to view: Constrainable? = nil,
                    priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {

        guard let view = view ?? `super` else { return [] }
        prepareForLayout()

        let constraints = edges.map { $0.constraint(self, to: view) }
        NSLayoutConstraint.activate(constraints, priority: priority)

        return constraints
    }

    @discardableResult
    public func center(in view: Constrainable? = nil,
                       axes: [LayoutAxis] = .all,
                       priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {

        guard let view = view ?? `super` else { return [] }
        prepareForLayout()

        let constraints = axes.map { $0.constraint(self, to: view) }
        NSLayoutConstraint.activate(constraints, priority: priority)

        return constraints
    }

    @discardableResult
    public func size(_ dimensions: [LayoutDimension],
                     priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {

        prepareForLayout()

        let constraints = dimensions.map { $0.constraint(self) }
        NSLayoutConstraint.activate(constraints, priority: priority)

        return constraints
    }

    @discardableResult
    public func size(_ size: CGSize,
                     priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {

        return self.size([.width(size.width), .height(size.height)], priority: priority)
    }
}
