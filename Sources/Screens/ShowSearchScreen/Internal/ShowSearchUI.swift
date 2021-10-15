protocol ShowSearchUI: AnyObject {
    var searchQueryUpdateHandler: ((String?) -> Void)? { get set }
    var poweredByLinkTapHandler: (() -> Void)? { get set }

    func reload()
    func startActivityIndicator()
    func stopActivityIndicator()
}
