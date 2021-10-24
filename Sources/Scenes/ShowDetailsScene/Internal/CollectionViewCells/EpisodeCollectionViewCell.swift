import UIKit
import ConstraintLayout
import RemoteImageView
import CollapsingTextView
import Styling
import Resources

final class EpisodeCollectionViewCell: UICollectionViewCell {
    struct Episode {
        let stillURL: URL?
        let showBackdropURL: URL?
        let showPosterURL: URL?
        let seasonNumber: Int
        let number: Int
        let name: String
        let overview: String
        let localizedAirDate: String
        let isViewed: Bool
    }

    var viewButtonTapHandler: ((ViewButton.State) -> Void)? {
        didSet { updateUI() }
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .standardSpacing * 2
        return stackView
    }()

    private lazy var stillImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.translatesAutoresizingMaskIntoConstraints = false
        remoteImageView.backgroundColor = .clear
        remoteImageView.layer.cornerRadius = .standardSpacing * 2
        remoteImageView.layer.masksToBounds = true
        remoteImageView.contentMode = .scaleAspectFill
        return remoteImageView
    }()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .standardSpacing
        stackView.alignment = .center
        return stackView
    }()

    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .standardSpacing / 2
        return stackView
    }()

    private lazy var seasonAndEpisodeLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.highest, for: .vertical)
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.highest, for: .vertical)
        return label
    }()

    private lazy var viewButton: ViewButton = {
        let viewButton = ViewButton()
        viewButton.size = .tappable
        viewButton.setContentHuggingPriority(.required, for: .horizontal)
        viewButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        return viewButton
    }()

    private lazy var airDateContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = .standardSpacing * 2
        return view
    }()

    private lazy var airDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 6
        return stackView
    }()

    private lazy var airDateImageView: UIImageView = {
        let imageView = UIImageView(image: Images.clock.image)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.highest, for: .vertical)
        return imageView
    }()

    private lazy var airDateLabel = UILabel()

    private lazy var overviewText: CollapsingTextView = {
        let collapsingTextView = CollapsingTextView()

        collapsingTextView.readMoreButtonTapHandler = { [weak self] in
            guard let self = self else { return }

            UIView.animate(withDuration: 0.3) {
                self.contentStackView.layoutIfNeeded()

                UIView.animate(withDuration: 0.3) {
                    if self.stillImageView.alpha == 0 {
                        self.stillImageView.alpha = 1
                    } else if self.stillImageView.frame.height < self.stillImageView.layer.cornerRadius * 2 {
                        self.stillImageView.alpha = 0
                    }
                }
            }
        }

        return collapsingTextView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(stillImageView)
        contentStackView.addArrangedSubview(headerStackView)
        headerStackView.addArrangedSubview(nameStackView)
        nameStackView.addArrangedSubview(seasonAndEpisodeLabel)
        nameStackView.addArrangedSubview(nameLabel)
        headerStackView.addArrangedSubview(viewButton)
        contentStackView.addArrangedSubview(airDateContainerView)
        airDateContainerView.addSubview(airDateStackView)
        airDateStackView.addArrangedSubview(airDateImageView)
        airDateStackView.addArrangedSubview(airDateLabel)
        contentStackView.addArrangedSubview(overviewText)

        airDateStackView.pin(edges: .all(.standardSpacing * 1.5), priority: .highest)
        contentStackView.pin(edges: [.left, .right])
        contentStackView.pin(edges: [.top], priority: .highest - 1)

        NSLayoutConstraint.activate([
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            stillImageView.heightAnchor.constraint(lessThanOrEqualTo: stillImageView.widthAnchor, multiplier: 0.4),
        ])

        NSLayoutConstraint.activate([
            stillImageView.heightAnchor.constraint(equalTo: stillImageView.widthAnchor, multiplier: 0.4),
        ], priority: .defaultHigh)

        updateUI()
        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        overviewText.isCollapsed = true
        stillImageView.alpha = 1
    }

    // todo: move to presenter
    func configure(with episode: Episode?) {
        stillImageView.loadImage(with: episode?.stillURL,
                                 placeholderURL: episode?.showBackdropURL ?? episode?.showPosterURL)

        seasonAndEpisodeLabel.text = "S%02dE%02d".localized(comment: "Season & episode number",
                                                            episode?.seasonNumber ?? 0,
                                                            episode?.number ?? 0)

        nameLabel.text = episode?.name
        overviewText.text = episode?.overview
        viewButton.state = .viewed(episode?.isViewed == true)

        if let localizedAirDate = episode?.localizedAirDate {
            airDateContainerView.isHidden = false
            airDateLabel.text = localizedAirDate
        } else {
            airDateContainerView.isHidden = true
        }
    }
}

extension EpisodeCollectionViewCell: Themeable {
    func apply(theme: Theme) {
        seasonAndEpisodeLabel.textColor = theme.colors.foregroundPrimary
        nameLabel.textColor = theme.colors.foregroundPrimary
        airDateContainerView.backgroundColor = theme.colors.brandPrimary.withAlphaComponent(0.05)
        airDateImageView.tintColor = theme.colors.brandPrimary
        airDateLabel.textColor = theme.colors.brandPrimary

        seasonAndEpisodeLabel.font = theme.fonts.title3
        nameLabel.font = theme.fonts.headline
        airDateLabel.font = theme.fonts.body
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension EpisodeCollectionViewCell {
    func updateUI() {
        viewButton.tapHandler = viewButtonTapHandler
    }
}
