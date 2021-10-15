public protocol Finalizable {
    associatedtype Value

    @discardableResult
    func finally(on context: ExecutionContext, completion: @escaping () -> Void) -> Disposable

    @discardableResult
    func execute(on context: ExecutionContext, completion: @escaping Promise<Value>.Completion) -> Disposable

    @discardableResult
    func execute(on context: ExecutionContext) -> Disposable
}
