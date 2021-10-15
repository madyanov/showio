import Foundation

public func debounce<Input, Output>(on context: ExecutionContext = DispatchQueue.main,
                                   _ interval: TimeInterval,
                                   _ work: @escaping (Input) -> Promise<Output>) -> (Input) -> Promise<Output> {

    var task: DispatchWorkItem?

    return { input in
        Promise { completion in
            task?.cancel()
            task = DispatchWorkItem { work(input).execute(on: context, completion: completion) }

            if let task = task {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: task)
            }
        }
    }
}
