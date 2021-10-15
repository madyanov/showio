public protocol ExecutionContext {
    func execute(_ work: @escaping () -> Void)
}
