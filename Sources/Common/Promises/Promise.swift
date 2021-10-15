import Dispatch

public struct Promise<Value> {
    public typealias Completion = (Result<Value>) -> Void

    public static var nothing: Promise { .failure(PromiseError.nothing) }

    let disposeBox = DisposeBox()
    let work: (@escaping Completion) -> Void

    public init(_ work: @escaping (@escaping Completion) throws -> Void) {
        self.work = { completion in
            do {
                try work { completion($0) }
            } catch {
                completion(.failure(error))
            }
        }
    }

    public init(value: Value) {
        self.init { $0(.success(value)) }
    }

    public init(error: Error) {
        self.init { $0(.failure(error)) }
    }

    public static func success(_ value: Value) -> Promise {
        return Promise(value: value)
    }

    public static func failure(_ error: Error) -> Promise {
        return Promise(error: error)
    }

    private init(_ box: DisposeBox? = nil,
                 _ work: @escaping (@escaping Completion) throws -> Void) {

        self.init(work)
        box?.move(to: disposeBox)
    }

    public func then<NewValue>(on context: ExecutionContext = DispatchQueue.main,
                                _ work: @escaping (Value) throws -> Promise<NewValue>) -> Promise<NewValue> {

        return Promise<NewValue>(disposeBox) { completion in
            execute(on: context) {
                switch $0 {
                case .success(let value):
                    do {
                        try work(value).execute(on: context, completion: completion)
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func map<NewValue>(on context: ExecutionContext = DispatchQueue.main,
                              _ work: @escaping (Value) throws -> NewValue) -> Promise<NewValue> {

        return then(on: context) { .success(try work($0)) }
    }

    public func `continue`(on context: ExecutionContext = DispatchQueue.main,
                           _ work: @escaping (Value) throws -> Void) -> Promise {

        return Promise(disposeBox) { completion in
            execute(on: context) {
                switch $0 {
                case .success(let value):
                    do {
                        try work(value)
                        completion(.success(value))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    public func always(on context: ExecutionContext = DispatchQueue.main,
                       _ work: @escaping () throws -> Void) -> Promise {

        return Promise(disposeBox) { completion in
            execute(on: context) {
                do {
                    try work()
                    completion($0)
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    public func done(on context: ExecutionContext = DispatchQueue.main,
                     _ work: @escaping (Value) throws -> Void) -> Promise<Void> {

        return map(on: context, work)
    }

    public func recover(on context: ExecutionContext = DispatchQueue.main,
                        _ recovery: @escaping (Error) throws -> Promise) -> Promise {

        return Promise(disposeBox) { completion in
            execute(on: context) {
                switch $0 {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    do {
                        try recovery(error).execute(on: context, completion: completion)
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    public func recover(on context: ExecutionContext = DispatchQueue.main,
                        _ recovery: @escaping () throws -> Promise) -> Promise {

        return recover(on: context) { _ in try recovery() }
    }

    public func `catch`(on context: ExecutionContext = DispatchQueue.main,
                        _ handler: @escaping (Swift.Error) -> Void) -> Finalizer<Value> {

        let promise = Promise(disposeBox) { completion in
            execute(on: context) {
                switch $0 {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    handler(error)
                }
            }
        }

        return Finalizer(promise: promise)
    }
}
