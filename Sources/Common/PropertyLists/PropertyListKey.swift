public class PropertyListKeys { }

public final class PropertyListKey<N, T>: PropertyListKeys {
    let name: String

    public init(_ name: String) {
        self.name = name
    }
}
