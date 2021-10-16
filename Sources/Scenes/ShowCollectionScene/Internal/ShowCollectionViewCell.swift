import UIKit
import ConstraintLayout
import RemoteImageView
import Resources
import Styling
import ProgressBarView

final class ShowCollectionViewCell: UICollectionViewCell {
    var shouldCancelTapGesture = false

    var style = ShowCollectionStyle.default {
        didSet { themeProvider.reload(self) }
    }

    private var tapHandler: (() -> Void)?
    private var deleteActionHandler: (() -> Void)?

    private var isDummy = false {
        didSet { updateUI() }
    }

    private lazy var posterImageView: RemoteImageView = {
        let remoteImageView = RemoteImageView()
        remoteImageView.backgroundColor = .clear
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.layer.masksToBounds = true
        remoteImageView.layer.cornerRadius = .standardSpacing
        return remoteImageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .standardSpacing
        return stackView
    }()

    private lazy var posterContainerView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = .standardSpacing
        view.layer.shadowOffset = CGSize(width: 0, height: .standardSpacing / 2)
        return view
    }()

    private lazy var posterPlaceholderImageView: UIImageView = {
        let imageView = UIImageView(image: Images.nosign.image)
        imageView.isHidden = true
        imageView.contentMode = .center
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = .standardSpacing
        return imageView
    }()

    private lazy var progressBarView: ProgressBarView = {
        let progressBarView = ProgressBarView()
        progressBarView.shouldRoundCorners = false
        return progressBarView
    }()

    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = .standardSpacing
        return stackView
    }()

    private lazy var nameLabel = UILabel()
    private lazy var yearLabel = UILabel()

    private lazy var dummyBlurredOverlay: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.alpha = 0
        return visualEffectView
    }()

    private lazy var dummyActivityIndicatorView = UIActivityIndicatorView(style: .white)

    private lazy var numberOfNewEpisodesBadge: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red.withAlphaComponent(0.9)
        button.layer.cornerRadius = .standardSpacing

        button.contentEdgeInsets = UIEdgeInsets(top: .standardSpacing / 2,
                                                left: .standardSpacing * 0.75,
                                                bottom: .standardSpacing / 2,
                                                right: .standardSpacing * 0.75)
        return button
    }()

    private lazy var touchGestureRecognizer: UILongPressGestureRecognizer = {
        let longPresGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTouch))
        longPresGestureRecognizer.delegate = self
        longPresGestureRecognizer.minimumPressDuration = 0
        return longPresGestureRecognizer
    }()

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))

    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(touchGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)

        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(posterContainerView)
        posterContainerView.addSubview(posterImageView)
        posterContainerView.addSubview(posterPlaceholderImageView)
        posterImageView.addSubview(progressBarView)
        contentStackView.addArrangedSubview(footerStackView)
        footerStackView.addArrangedSubview(nameLabel)
        footerStackView.addArrangedSubview(yearLabel)
        posterImageView.addSubview(dummyBlurredOverlay)
        posterImageView.addSubview(numberOfNewEpisodesBadge)
        dummyBlurredOverlay.contentView.addSubview(dummyActivityIndicatorView)

        contentStackView.pin()
        posterImageView.pin()
        posterPlaceholderImageView.pin()
        dummyBlurredOverlay.pin()
        dummyActivityIndicatorView.center()

        progressBarView.pin(edges: [.leading, .trailing, .bottom])

        NSLayoutConstraint.activate([
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5),

            numberOfNewEpisodesBadge.topAnchor.constraint(equalTo: posterImageView.topAnchor,
                                                          constant: .standardSpacing),
            numberOfNewEpisodesBadge.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor,
                                                               constant: -.standardSpacing),
        ])

        updateUI()
        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // workaround to set correct shadow path after device rotation
        DispatchQueue.main.async {
            self.posterContainerView.layer.shadowPath = UIBezierPath(
                roundedRect: self.posterContainerView.layer.bounds,
                cornerRadius: self.posterImageView.layer.cornerRadius
            ).cgPath
        }
    }

    func configure(with show: ShowViewModel) {
        posterPlaceholderImageView.isHidden = true

        posterImageView.loadImage(with: show.posterURL) { [weak self] success in
            self?.posterPlaceholderImageView.isHidden = success
        }

        nameLabel.text = show.name
        yearLabel.text = show.firstAirDateYear
        isDummy = show.isDummy
        progressBarView.progress = show.progress
        progressBarView.isHidden = progressBarView.progress == 0

        if show.numberOfNewEpisodes > 0 {
            numberOfNewEpisodesBadge.isHidden = false
            numberOfNewEpisodesBadge.setTitle("+\(show.numberOfNewEpisodes)", for: .normal)
        } else {
            numberOfNewEpisodesBadge.isHidden = true
        }

        tapHandler = show.tap
        deleteActionHandler = show.delete
    }

    @objc
    func deleteAction() {
        deleteActionHandler?()
    }
}

extension ShowCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        return true
    }
}

extension ShowCollectionViewCell: Themeable {
    func apply(theme: Theme) {
        progressBarView.backgroundColor = theme.colors.backgroundPrimary.withAlphaComponent(0.8)
        nameLabel.textColor = theme.colors.foregroundPrimary
        yearLabel.textColor = theme.colors.foregroundSecondary
        posterPlaceholderImageView.backgroundColor = theme.colors.backgroundSecondary
        posterPlaceholderImageView.tintColor = theme.colors.foregroundSecondary

        numberOfNewEpisodesBadge.titleLabel?.font = theme.fonts.footnote
        yearLabel.font = style == .default ? theme.fonts.callout : theme.fonts.footnote
        nameLabel.font = style == .default ? theme.fonts.body : theme.fonts.footnote
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension ShowCollectionViewCell {
    func updateUI() {
        if isDummy {
            dummyActivityIndicatorView.startAnimating()
            dummyBlurredOverlay.alpha = 1
        } else {
            dummyActivityIndicatorView.startAnimating()

            UIView.animate(withDuration: 0.3) {
                self.dummyBlurredOverlay.alpha = 0
            }
        }
    }

    @objc
    func didTouch(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard !isDummy else { return }

        UIView.animate(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            switch gestureRecognizer.state {
            case .began:
                self.shouldCancelTapGesture = false
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            default:
                self.transform = .identity
            }
        })
    }

    @objc
    func didTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard !isDummy, !shouldCancelTapGesture else { return }
        tapHandler?()
    }
}
