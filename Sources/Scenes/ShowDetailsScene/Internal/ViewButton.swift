import UIKit
import HighlightingButton
import Resources
import Styling

final class ViewButton: UIView {
    enum State {
        case hidden
        case viewed(Bool)
    }

    var state: State = .hidden {
        didSet {
            let scaledTransform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            viewButton.layer.removeAllAnimations()
            unseeButton.layer.removeAllAnimations()

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .allowUserInteraction,
                animations: {
                    switch self.state {
                    case .hidden:
                        self.viewButton.alpha = 0
                        self.unseeButton.alpha = 0
                        self.viewButton.transform = scaledTransform
                        self.unseeButton.transform = scaledTransform
                    case .viewed(true):
                        self.viewButton.alpha = 0
                        self.unseeButton.alpha = 1
                        self.viewButton.transform = scaledTransform
                        self.unseeButton.transform = .identity
                    case .viewed(false):
                        self.viewButton.alpha = 1
                        self.unseeButton.alpha = 0
                        self.viewButton.transform = .identity
                        self.unseeButton.transform = scaledTransform
                    }
                },
                completion: nil
            )
        }
    }

    var tapHandler: ((State) -> Void)?
    var size = CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)

    override var intrinsicContentSize: CGSize { size }

    private lazy var viewButton: HighlightingButton = {
        let button = HighlightingButton()
        button.alpha = 0
        button.highlightedAlpha = 0.5
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = .standardSpacing * 1.5
        button.setImage(Images.eye.image, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    private lazy var unseeButton: HighlightingButton = {
        let button = HighlightingButton()
        button.alpha = 0
        button.highlightedAlpha = 0.5
        button.setImage(Images.checkmark.image, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)

        addSubview(viewButton)
        addSubview(unseeButton)

        viewButton.pin()
        unseeButton.pin()

        widthAnchor.constraint(equalTo: heightAnchor).isActive = true

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewButton: Themeable {
    func apply(theme: Theme) {
        unseeButton.tintColor = theme.colors.brandPrimary
        viewButton.tintColor = theme.colors.brandPrimary
        viewButton.layer.borderColor = theme.colors.brandPrimary.cgColor
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

extension ViewButton {
    @objc
    private func didTap() {
        tapHandler?(state)
    }
}
