public enum Result<Value> {
    case success(Value)
    case failure(Error)
}

extension Result where Value == Void {
    public static var success: Result { .success(()) }
}
