public protocol Disposable {
    func disposed(by box: DisposeBox)
}
