import UIKit
import CommonCrypto

public final class ImageCache {
    public static let shared = ImageCache(directoryName: "Cached Images")

    private class CacheRecord: NSObject {
        let data: Data
        let isPersistent: Bool

        init(data: Data, isPersistent: Bool) {
            self.data = data
            self.isPersistent = isPersistent
        }
    }

    private lazy var cache = NSCache<NSURL, CacheRecord>()

    private lazy var cachedImagesDirectory: URL? = {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

        guard let cachedImagesDirectory = documentDirectory?.appendingPathComponent(directoryName) else {
            return nil
        }

        try? fileManager.createDirectory(atPath: cachedImagesDirectory.path,
                                         withIntermediateDirectories: true,
                                         attributes: nil)

        return cachedImagesDirectory
    }()

    private let directoryName: String
    private let fileManager: FileManager
    private let queue: DispatchQueue

    public init(directoryName: String,
                fileManager: FileManager = .default,
                queue: DispatchQueue = .global(qos: .background)) {

        self.directoryName = directoryName
        self.fileManager = fileManager
        self.queue = queue
    }

    public func warmUp(limit: Int) {
        guard let cachedImagesDirectory = cachedImagesDirectory else { return }

        queue.async {
            let urls = try? self.fileManager.contentsOfDirectory(at: cachedImagesDirectory,
                                                                 includingPropertiesForKeys: nil)

            urls?.map { cachedImagesDirectory.appendingPathComponent($0.lastPathComponent) }
                .prefix(limit)
                .forEach {
                    guard
                        let data = try? Data(contentsOf: $0),
                        UIImage(data: data) != nil
                    else {
                        return
                    }

                    self.saveDataToMemory(data, persistent: true, localURL: $0)
                }
        }
    }

    public func clear(for url: URL) {
        guard let localURL = localImageURL(forRemote: url) else { return }
        cache.removeObject(forKey: localURL as NSURL)
        try? fileManager.removeItem(at: localURL)
    }

    func image(for url: URL, persistent: Bool) -> UIImage? {
        guard let localURL = localImageURL(forRemote: url) else { return nil }

        if let cacheRecord = cache.object(forKey: localURL as NSURL),
           let image = UIImage(data: cacheRecord.data) {

            // copy data from memory to filesystem
            if persistent && !cacheRecord.isPersistent {
                queue.async {
                    self.save(data: cacheRecord.data, for: url, persistent: persistent)
                }
            }

            return image
        }

        guard
            let data = try? Data(contentsOf: localURL),
            let image = UIImage(data: data)
        else {
            return nil
        }

        saveDataToMemory(data, persistent: persistent, localURL: localURL)
        return image
    }

    func save(data: Data, for url: URL, persistent: Bool) {
        guard let localURL = localImageURL(forRemote: url) else { return }

        if UIImage(data: data) != nil {
            saveDataToMemory(data, persistent: persistent, localURL: localURL)
        }

        if persistent {
            try? data.write(to: localURL)
        }
    }
}

private extension ImageCache {
    func localImageURL(forRemote url: URL) -> URL? {
        guard
            let sha1 = url.absoluteString.sha1,
            let cachedImagesDirectory = cachedImagesDirectory
        else {
            return nil
        }

        let fileName = url.lastPathComponent.prefix(16)
        return cachedImagesDirectory.appendingPathComponent("\(fileName)_\(sha1)")
    }

    func saveDataToMemory(_ data: Data, persistent: Bool, localURL: URL) {
        let cacheRecord = CacheRecord(data: data, isPersistent: persistent)
        cache.setObject(cacheRecord, forKey: localURL as NSURL)
    }
}

private extension String {
    var sha1: String? {
        guard let data = self.data(using: .utf8) else { return nil }

        let hash: [UInt8] = data.withUnsafeBytes { pointer in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(pointer.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }

        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
