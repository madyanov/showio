import UIKit

public final class RemoteImageView: UIImageView {
    private lazy var blurView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.isHidden = true
        return visualEffectView
    }()

    private var urlSessionDataTask: URLSessionDataTask?
    private var url: URL?

    private let cache: ImageCache

    public init(cache: ImageCache = .shared) {
        self.cache = cache

        super.init(frame: .zero)

        addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func loadImage(with imageURL: URL?,
                          placeholderURL: URL? = nil,
                          persistent: Bool = false,
                          timeout: TimeInterval = 60,
                          completion: ((Bool) -> Void)? = nil) {

        image = nil

        if placeholderURL != nil {
            showBlur()
        }

        loadImage(with: placeholderURL, persistent: persistent, timeout: timeout) { _ in
            self.loadImage(with: imageURL, persistent: persistent, timeout: timeout) { success in
                if success, placeholderURL != nil, self.url == imageURL {
                    self.hideBlur()
                }

                completion?(success)
            }
        }
    }
}

private extension RemoteImageView {
    func loadImage(with imageURL: URL?,
                   persistent: Bool,
                   timeout: TimeInterval,
                   completion: @escaping (Bool) -> Void) {

        urlSessionDataTask?.cancel()

        guard let url = imageURL else {
            completion(false)
            return
        }

        if let image = cache.image(for: url, persistent: persistent) {
            DispatchQueue.main.async {
                self.showImage(image)
                completion(true)
            }

            return
        }

#if DEBUG
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeout)
#else
        let request = URLRequest(url: url, timeoutInterval: timeout)
#endif

        urlSessionDataTask = URLSession.shared
            .dataTask(with: request) { data, _, error in
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(false) }
                    return
                }

                self.cache.save(data: data, for: url, persistent: persistent)

                DispatchQueue.main.async {
                    self.showImage(image)
                    completion(true)
                }
            }

        urlSessionDataTask?.resume()
    }

    func showImage(_ image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: { self.image = image })
    }

    func showBlur() {
        blurView.effect = UIBlurEffect(style: .light)
        blurView.isHidden = false
    }

    func hideBlur() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.effect = nil
        }, completion: { _ in
            self.blurView.isHidden = true
        })
    }
}
