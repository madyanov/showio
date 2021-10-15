import Foundation

func main() {
    guard let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: "."),
                                                          includingPropertiesForKeys: [.isRegularFileKey],
                                                          options: .skipsHiddenFiles) else { return }

    let pattern = #""([^"]+)"[\s]*\.[\s]*localized[\s]*\([\s]*comment:[\s]*"([^"]+)""#
    guard let regexp = try? NSRegularExpression(pattern: pattern, options: []) else { return }

    var printed: Set<Substring> = []

    for case let fileURL as URL in enumerator where fileURL.pathExtension == "swift" {
        guard let content = try? String(contentsOf: fileURL) else { continue }

        let matches = regexp.matches(in: content, options: [], range: NSRange(content.startIndex..., in: content))

        for match in matches {
            guard let keyRange = Range(match.range(at: 1), in: content) else { continue }
            guard let commentRange = Range(match.range(at: 2), in: content) else { continue }

            let key = content[keyRange]
            let comment = content[commentRange]

            guard !printed.contains(key) else { continue }
            printed.insert(key)

            print()
            print("/* \(comment) */")
            print("\"\(key)\" = \"\(key)\";")
        }
    }
}

main()
