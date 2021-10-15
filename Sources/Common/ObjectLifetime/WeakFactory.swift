public final class WeakFactory<Type> {
    public var value: Type { (object as? Type) ?? create() }

    private weak var object: AnyObject?
    private let factory: () -> Type

    public init(_ factory: @escaping () -> Type) {
        self.factory = factory
    }
}

private extension WeakFactory {
    func create() -> Type {
        let object = factory()
        self.object = object as AnyObject
        return object
    }
}
