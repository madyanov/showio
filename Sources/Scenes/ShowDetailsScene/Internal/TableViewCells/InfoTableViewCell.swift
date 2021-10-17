import UIKit
import ConstraintLayout
import Localization
import HighlightingButton
import Styling
import Resources

final class InfoTableViewCell: UITableViewCell {
    struct Show {
        let rating: Float
        let episodeRunTime: Int
        let genre: String?
    }

    enum State {
        case hidden
        case exists(Bool)
    }

    var addButtonTapHandler: (() -> Void)?
    var deleteButtonTapHandler: (() -> Void)?

    var state: State = .hidden {
        didSet {
            let scaledTransform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            addButton.isUserInteractionEnabled = false
            deleteButton.isUserInteractionEnabled = false

            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: .allowUserInteraction,
                animations: {
                    switch self.state {
                    case .hidden:
                        self.addButton.alpha = 0
                        self.deleteButton.alpha = 0
                        self.addButton.transform = scaledTransform
                        self.deleteButton.transform = scaledTransform
                    case .exists(true):
                        self.addButton.alpha = 0
                        self.deleteButton.alpha = 1
                        self.deleteButton.isUserInteractionEnabled = true
                        self.addButton.transform = scaledTransform
                        self.deleteButton.transform = .identity
                    case .exists(false):
                        self.addButton.alpha = 1
                        self.deleteButton.alpha = 0
                        self.addButton.isUserInteractionEnabled = true
                        self.addButton.transform = .identity
                        self.deleteButton.transform = scaledTransform
                    }
                },
                completion: nil
            )
        }
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = .standardSpacing
        return stackView
    }()

    private lazy var infoContainerView = UIView()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()

    private lazy var starImageContainerView = UIView()

    private lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: Images.star.image)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private lazy var infoLabel = UILabel()
    private lazy var buttonContainerView = UIView()

    private lazy var addButton: HighlightingButton = {
        let button = HighlightingButton()
        button.alpha = 0
        button.highlightedAlpha = 0.5
        button.layer.borderWidth = 1
        button.layer.cornerRadius = .standardSpacing * 1.5
        button.setImage(Images.plus.image, for: .normal)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    private lazy var deleteButton: HighlightingButton = {
        let button = HighlightingButton()
        button.alpha = 0
        button.highlightedAlpha = 0.5
        button.setImage(Images.checkmark.image, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    private lazy var bottomLineView = UIView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(infoContainerView)
        infoContainerView.addSubview(infoStackView)
        infoStackView.addArrangedSubview(starImageContainerView)
        starImageContainerView.addSubview(starImageView)
        infoStackView.addArrangedSubview(infoLabel)
        contentStackView.addArrangedSubview(buttonContainerView)
        buttonContainerView.addSubview(addButton)
        buttonContainerView.addSubview(deleteButton)
        contentView.addSubview(bottomLineView)

        contentStackView.pin(edges: .vertical(.standardSpacing * 2) + .horizontal(.standardSpacing * 3))
        starImageView.pin(edges: [.left, .right, .top, .bottom(3)])
        buttonContainerView.size(.tappable)
        deleteButton.pin()
        addButton.pin()
        bottomLineView.size([.height(0.5)])

        NSLayoutConstraint.activate([
            infoStackView.leadingAnchor.constraint(equalTo: infoContainerView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(lessThanOrEqualTo: infoContainerView.trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),

            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .standardSpacing * 3),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // todo: move to presenter
    func setShow(_ show: Show?) {
        var ratingString: String?
        var episodeDurationString: String?

        if let rating = show?.rating, rating > 0 {
            ratingString = String(format: "%.1f", rating)
        }

        if let episodeRunTime = show?.episodeRunTime, episodeRunTime > 0 {
            episodeDurationString = "%d min".localized(comment: "Episode duration (minutes)", episodeRunTime)
        }

        infoLabel.text = [
            ratingString,
            show?.genre?.truncated(length: 16),
            episodeDurationString,
        ].compactMap { $0 }.joined(separator: " · ")

        starImageContainerView.isHidden = ratingString == nil
    }
}

extension InfoTableViewCell: Themeable {
    func apply(theme: Theme) {
        infoLabel.textColor = theme.colors.foregroundPrimary
        starImageView.tintColor = theme.colors.rating
        deleteButton.tintColor = theme.colors.brandPrimary
        bottomLineView.backgroundColor = theme.colors.foregroundPrimary.withAlphaComponent(0.1)
        addButton.tintColor = theme.colors.brandPrimary
        addButton.layer.borderColor = theme.colors.brandPrimary.cgColor

        infoLabel.font = theme.fonts.headline
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension InfoTableViewCell {
    @objc
    func didTapAddButton() {
        addButtonTapHandler?()
    }

    @objc
    func didTapDeleteButton() {
        deleteButtonTapHandler?()
    }
}

// todo: move to some package
private extension String {
    func truncated(length: Int, trailing: String = "…") -> String {
        return count > length ? prefix(length) + trailing : self
    }
}
