public final class WeakLazy<Type> {
    public var value: Type { (object as? Type) ?? create() }

    private weak var object: AnyObject?
    private let factory: () -> Type

    public init(_ factory: @escaping () -> Type) {
        self.factory = factory
    }

    public func callAsFunction<NewType>(_ cast: @escaping (Type) -> NewType) -> WeakLazy<NewType> {
        return WeakLazy<NewType> { cast(self.value) }
    }
}

private extension WeakLazy {
    func create() -> Type {
        let object = factory()
        self.object = object as AnyObject
        return object
    }
}
