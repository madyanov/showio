public struct Finalizer<Value> {
    private let promise: Promise<Value>

    init(promise: Promise<Value>) {
        self.promise = promise
    }
}

extension Finalizer: Finalizable {
    @discardableResult
    public func finally(on context: ExecutionContext, completion: @escaping () -> Void) -> Disposable {
        return promise.finally(on: context, completion: completion)
    }

    @discardableResult
    public func execute(on context: ExecutionContext,
                        completion: @escaping Promise<Value>.Completion) -> Disposable {

        return promise.execute(on: context, completion: completion)
    }

    @discardableResult
    public func execute(on context: ExecutionContext) -> Disposable {
        return promise.execute(on: context)
    }
}
