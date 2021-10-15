public enum PropertyListError: Error {
    case fileNotFound
    case fileNotReadable(Error)
    case invalidPropertyList(Error)
}
