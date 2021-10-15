import Dispatch

public func firstly<Value>(_ work: @escaping () throws -> Promise<Value>) -> Promise<Value> {
    do {
        return try work()
    } catch {
        return .failure(error)
    }
}
