public final class DisposeBox {
    private final class Resource { }

    private var strong: Resource?
    private weak var weak: Resource?

    var isDisposed: Bool { weak == nil }

    public init() {
        strong = Resource()
        weak = strong
    }

    func move(to box: DisposeBox) {
        defer { free() }
        box.strong = strong
        box.weak = box.strong
    }

    func free() {
        strong = nil
    }
}
