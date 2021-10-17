import UIKit
import ConstraintLayout
import Localization
import Styling
import ShowCollectionScene

public final class ShowSearchView: UIView {
    public var poweredByLinkTapHandler: (() -> Void)?

    public weak var dataSource: ShowCollectionViewDataSource? {
        get { showCollectionView.dataSource }
        set { showCollectionView.dataSource = newValue }
    }

    private lazy var blurredHeaderView = UIVisualEffectView()

    private lazy var showCollectionView: ShowCollectionView = {
        let showCollectionView = ShowCollectionView()
        showCollectionView.style = traitCollection.userInterfaceIdiom == .pad ? .default : .minimal
        return showCollectionView
    }()

    private lazy var poweredByLabel: UILabel = {
        let string = "Powered by TheMovieDB".localized(comment: "The Movie DB attribution label")
        let attributedString = NSMutableAttributedString(string: string)

        attributedString.setAttributes([.underlineStyle: 1],
                                       range: (string as NSString).range(of: "TheMovieDB"))

        let label = UILabel()
        label.alpha = 0
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPoweredByLabel)))
        return label
    }()

    private lazy var activityIndicatorLayoutGuide = UILayoutGuide()
    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private lazy var poweredByLabelCollapsedHeightConstraint =
        poweredByLabel.heightAnchor.constraint(equalToConstant: 0)

    private lazy var blurredHeaderViewBottomConstraint =
        blurredHeaderView.bottomAnchor.constraint(equalTo: poweredByLabel.bottomAnchor)

    public init() {
        super.init(frame: .zero)

        addSubview(showCollectionView)
        addSubview(blurredHeaderView)
        addSubview(poweredByLabel)
        addSubview(activityIndicatorView)

        addLayoutGuide(activityIndicatorLayoutGuide)

        showCollectionView.pin(edges: [.top, .bottom])
        showCollectionView.pin(edges: [.left, .right], to: safeArea)
        blurredHeaderView.pin(edges: [.top, .left, .right])
        activityIndicatorLayoutGuide.pin(edges: [.top, .left, .right])
        activityIndicatorView.center(in: activityIndicatorLayoutGuide, priority: .defaultLow)
        poweredByLabel.center(axes: [.x])
        poweredByLabel.pin(edges: [.top(.standardSpacing / 2)], to: safeArea)

        NSLayoutConstraint.activate([
            activityIndicatorView.topAnchor.constraint(greaterThanOrEqualTo: poweredByLabel.bottomAnchor,
                                                       constant: .standardSpacing * 4),
        ], priority: .defaultHigh)

        NSLayoutConstraint.activate([
            blurredHeaderViewBottomConstraint,
            activityIndicatorLayoutGuide.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
        ])

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if traitCollection.verticalSizeClass == .regular {
            blurredHeaderViewBottomConstraint.constant = .standardSpacing * 1.5
            poweredByLabelCollapsedHeightConstraint.isActive = false
        } else {
            blurredHeaderViewBottomConstraint.constant = -.standardSpacing / 2
            poweredByLabelCollapsedHeightConstraint.isActive = true
        }

        showCollectionView.additionalVerticalInset =
            poweredByLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height +
            blurredHeaderViewBottomConstraint.constant + .standardSpacing / 2
    }

    public func showBlurredHeader() {
        blurredHeaderView.effect = UIBlurEffect(style: themeProvider.theme.styles.blur)
    }

    public func hideBlurredHeader() {
        blurredHeaderView.effect = nil
    }

    public func updatePoweredByLabelPosition() {
        // workaround to properly layout attribution label
        poweredByLabel.setNeedsUpdateConstraints()
        poweredByLabel.updateConstraintsIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.poweredByLabel.alpha = 1
        }
    }

    public func reload() {
        showCollectionView.reloadData()
    }

    public func startActivityIndicator() {
        activityIndicatorView.startAnimating()
    }

    public func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
}

extension ShowSearchView: Themeable {
    public func apply(theme: Theme) {
        showBlurredHeader()

        backgroundColor = theme.colors.backgroundPrimary
        poweredByLabel.textColor = theme.colors.foregroundSecondary

        activityIndicatorView.style = theme.styles.activityIndicator

        poweredByLabel.font = theme.fonts.footnote
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension ShowSearchView {
    @objc
    func didTapPoweredByLabel() {
        poweredByLinkTapHandler?()
    }
}
