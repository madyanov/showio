import UIKit
import ConstraintLayout
import Styling
import Resources

final class EndingCollectionViewCell: UICollectionViewCell {
    enum State {
        case loading
        case finished
        case pending(nextEpisodeAirDate: String?)
    }

    var state: State = .loading {
        didSet {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            finishFlagImageView.isHidden = true

            switch state {
            case .loading:
                activityIndicatorView.isHidden = false
                activityIndicatorView.startAnimating()
            case .finished:
                finishFlagImageView.isHidden = false
            case .pending(let nextEpisodeAirDate):
                clockImageView.isHidden = false
                nextEpisodeAirDateLabel.isHidden = nextEpisodeAirDate == nil
                nextEpisodeAirDateLabel.text = nextEpisodeAirDate
            }
        }
    }

    private lazy var containerLayoutGuide = UILayoutGuide()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()

    private lazy var finishFlagImageView: UIImageView = {
        let imageView = UIImageView(image: Images.flag.image)
        imageView.isHidden = true
        return imageView
    }()

    private lazy var clockImageView: UIImageView = {
        let imageView = UIImageView(image: Images.clock.image)
        imageView.isHidden = true
        return imageView
    }()

    private lazy var imageContainerView = UIView()

    private lazy var nextEpisodeAirDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(imageContainerView)
        imageContainerView.addSubview(finishFlagImageView)
        imageContainerView.addSubview(clockImageView)
        contentView.addSubview(nextEpisodeAirDateLabel)

        contentView.addLayoutGuide(containerLayoutGuide)

        activityIndicatorView.center(in: containerLayoutGuide)
        imageContainerView.center(in: containerLayoutGuide)
        finishFlagImageView.pin()
        clockImageView.pin()
        containerLayoutGuide.pin(edges: [.left, .right, .top])

        NSLayoutConstraint.activate([
            containerLayoutGuide.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),

            nextEpisodeAirDateLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 32),
            nextEpisodeAirDateLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nextEpisodeAirDateLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -32),
        ])

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EndingCollectionViewCell: Themeable {
    func apply(theme: Theme) {
        finishFlagImageView.tintColor = theme.colors.brandPrimary.withAlphaComponent(0.67)
        clockImageView.tintColor = theme.colors.brandPrimary.withAlphaComponent(0.67)
        nextEpisodeAirDateLabel.textColor = theme.colors.brandPrimary
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}
