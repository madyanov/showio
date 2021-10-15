import Dispatch

extension Promise: Finalizable {
    @discardableResult
    public func finally(on context: ExecutionContext = DispatchQueue.main,
                        completion: @escaping () -> Void) -> Disposable {

        return execute(on: context) { _ in completion() }
    }

    @discardableResult
    public func execute(on context: ExecutionContext = DispatchQueue.main,
                        completion: @escaping Completion) -> Disposable {

        work { result in
            guard !disposeBox.isDisposed else { return }
            disposeBox.free()

            context.execute { completion(result) }
        }

        return self
    }

    @discardableResult
    public func execute(on context: ExecutionContext = DispatchQueue.main) -> Disposable {
        return finally(on: context) { }
    }
}
