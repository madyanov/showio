extension Promise: Disposable {
    public func disposed(by box: DisposeBox) {
        disposeBox.move(to: box)
    }
}
