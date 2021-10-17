import UIKit
import ConstraintLayout
import RemoteImageView
import GradientView
import Resources
import Styling

final class HeaderView: UIView {
    var closeButtonTapHandler: (() -> Void)?

    private lazy var gradientView = GradientView(colors: [
        .black.withAlphaComponent(0.1),
        .black.withAlphaComponent(0.3),
    ])

    private lazy var backdropImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.backgroundColor = .clear
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.clipsToBounds = true
        return remoteImageView
    }()

    private lazy var headerBarView =  UIView()

    private lazy var collapsedNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.chevronDown.image, for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private lazy var posterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .standardSpacing
        stackView.alignment = .bottom
        return stackView
    }()

    private lazy var posterImageContainerView: UIView = {
        let view = UIView()
        view.layer.shadowRadius = .standardSpacing
        view.layer.shadowOffset = CGSize(width: 0, height: .standardSpacing / 2)
        view.layer.shadowOpacity = 0.2
        return view
    }()

    private lazy var posterImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.backgroundColor = .clear
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.layer.cornerRadius = .standardSpacing
        remoteImageView.layer.masksToBounds = true
        return remoteImageView
    }()

    private lazy var posterInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .standardSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    init() {
        super.init(frame: .zero)

        addSubview(backdropImageView)
        backdropImageView.addSubview(gradientView)
        addSubview(posterStackView)
        posterStackView.addArrangedSubview(posterImageContainerView)
        posterImageContainerView.addSubview(posterImageView)
        posterStackView.addArrangedSubview(posterInfoStackView)
        posterInfoStackView.addArrangedSubview(nameLabel)
        posterInfoStackView.addArrangedSubview(yearLabel)
        addSubview(headerBarView)
        headerBarView.addSubview(collapsedNameLabel)
        headerBarView.addSubview(closeButton)

        backdropImageView.pin()
        gradientView.pin()
        posterImageView.pin(priority: .highest)
        posterImageView.pin(edges: [.bottom(0)]) // posterOverlapping
        collapsedNameLabel.pin(edges: [.top, .bottom, .left(56), .right(56)])
        closeButton.pin(edges: [.top, .bottom, .right])
        closeButton.size([.width(56)])
        headerBarView.pin(edges: [.top, .left, .right], to: safeArea, priority: .highest)
        headerBarView.size([.height(0)]) // collapsedHeaderHeight
        backdropImageView.center(axes: [.x])
        posterStackView.pin(edges: [.bottom(.standardSpacing * 2)])
        posterStackView.pin(edges: [.leading(.standardSpacing * 3), .trailing(.standardSpacing * 3)],
                            to: safeArea,
                            priority: .highest)
        posterStackView.size([.height(0)]) // posterHeight

        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            posterImageView.heightAnchor.constraint(lessThanOrEqualTo: posterImageContainerView.heightAnchor),
        ])

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderView: Themeable {
    public func apply(theme: Theme) {
        collapsedNameLabel.font = theme.fonts.title3
        nameLabel.font = theme.fonts.title1
        yearLabel.font = theme.fonts.body
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension HeaderView {
    @objc
    func didTapCloseButton() {
        closeButtonTapHandler?()
    }
}

private extension UILayoutPriority {
    static let highest = UILayoutPriority(999)
}
