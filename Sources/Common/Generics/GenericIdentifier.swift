public struct GenericIdentifier<Tag, Value: Hashable>: Identifiable, RawRepresentable {
    public var id: Value { rawValue }

    public let rawValue: Value

    public init(rawValue: Value) {
        self.rawValue = rawValue
    }

    public static func id(_ rawValue: Value) -> GenericIdentifier {
        return GenericIdentifier(rawValue: rawValue)
    }
}
