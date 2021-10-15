import UIKit
import ConstraintLayout
import GradientView
import RemoteImageView
import Resources
import Styling

public final class HeaderView: UIView {
//    private let posterOverlapping: CGFloat = .standardSpacing * 3

    private lazy var headerGradientView: GradientView = {
        let gradientView = GradientView()

        gradientView.colors = [
            UIColor.black.withAlphaComponent(0.1),
            UIColor.black.withAlphaComponent(0.3),
        ]

        return gradientView
    }()

    private lazy var backdropImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.backgroundColor = .clear
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.clipsToBounds = true
        return remoteImageView
    }()

    private lazy var headerBarView = UIView()

    private lazy var collapsedNameLabel: UILabel = {
        let label = UILabel()
//        label.setTextStyle(.title3)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.chevronDown.image, for: .normal)
//        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private lazy var posterStackView: UIStackView = {
        let stackView = UIStackView()
//        stackView.spacing = .standardSpacing
        stackView.alignment = .bottom
        return stackView
    }()

    private lazy var posterImageContainerView: UIView = {
        let view = UIView()
//        view.layer.shadowRadius = .standardSpacing
//        view.layer.shadowOffset = CGSize(width: 0, height: .standardSpacing / 2)
        view.layer.shadowOpacity = 0.2
        return view
    }()

    private lazy var posterImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.backgroundColor = .clear
        remoteImageView.contentMode = .scaleAspectFill
//        cachedImageView.layer.cornerRadius = .standardSpacing
        remoteImageView.layer.masksToBounds = true
        return remoteImageView
    }()

    private lazy var posterInfoStackView: UIStackView = {
        let stackView = UIStackView()
//        stackView.spacing = .standardSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
//        label.setTextStyle(.title1)
        label.textColor = .white
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var yearLabel: UILabel = {
        let label = UILabel()
//        label.setTextStyle(.body)
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    public init() {
        super.init(frame: .zero)

        addSubview(backdropImageView)
        backdropImageView.addSubview(headerGradientView)
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
        headerGradientView.pin()
        posterImageView.pin(priority: .highest)
        collapsedNameLabel.pin(edges: [.top, .bottom, .left(56), .right(56)])
        closeButton.pin(edges: [.top, .bottom, .trailing])
        headerBarView.pin(edges: [.left, .right], to: safeArea)

        NSLayoutConstraint.activate([
            backdropImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            headerBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerBarView.heightAnchor.constraint(equalToConstant: 44),

            closeButton.widthAnchor.constraint(equalToConstant: 56),

            posterStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(111 * 2)),
            posterStackView.heightAnchor.constraint(equalToConstant: 222),

            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),
            posterImageView.heightAnchor.constraint(lessThanOrEqualTo: posterImageContainerView.heightAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 111),
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

    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension UILayoutPriority {
    static let highest = UILayoutPriority(999)
}
