import Foundation

public final class PropertyList<Tag> {
    private let propertyList: [String: Any]

    public init(name: String, bundle: Bundle = .main, extension: String = "plist") throws {
        guard let fileURL = bundle.url(forResource: name, withExtension: `extension`) else {
            throw PropertyListError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: fileURL)

            do {
                propertyList = try PropertyListSerialization.propertyList(from: data,
                                                                          options: [],
                                                                          format: nil) as? [String: Any] ?? [:]
            } catch {
                throw PropertyListError.invalidPropertyList(error)
            }
        } catch {
            throw PropertyListError.fileNotReadable(error)
        }
    }

    public subscript<Value>(key: PropertyListKey<Tag, Value>) -> Value? {
        return propertyList[key.name] as? Value
    }
}
