public final class SearchQueryFilterUseCase {
    public func filter(query: String?) -> String {
        return query?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
}
