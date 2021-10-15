import UIKit

extension Constrainable {
    public func pin(edges: [LayoutEdge] = .all,
                    to view: Constrainable? = nil,
                    priority: UILayoutPriority = .required) {

        guard let view = view ?? `super` else { return }
        prepareForLayout()

        let constraints = edges.map { $0.constraint(self, to: view) }
        NSLayoutConstraint.activate(constraints, priority: priority)
    }

    public func center(in view: Constrainable? = nil,
                       offset: CGPoint = .zero,
                       priority: UILayoutPriority = .required) {

        guard let view = view ?? `super` else { return }
        prepareForLayout()

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y),
        ], priority: priority)
    }

    public func size(_ size: CGSize, priority: UILayoutPriority = .required) {
        prepareForLayout()

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height),
        ], priority: priority)
    }
}
