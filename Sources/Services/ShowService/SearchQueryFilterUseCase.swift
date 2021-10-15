public final class SearchQueryFilterUseCase {
    public init() { }

    public func filter(query: String?) -> String {
        return query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
