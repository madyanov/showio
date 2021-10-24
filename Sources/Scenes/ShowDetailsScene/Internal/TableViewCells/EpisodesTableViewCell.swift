import UIKit
import ConstraintLayout
import GradientView
import Styling

final class EpisodesTableViewCell: UITableViewCell {
    weak var episodesCollectionViewDelegate: EpisodesCollectionViewDelegate? {
        get { episodesCollectionView.delegate }
        set { episodesCollectionView.delegate = newValue }
    }

    weak var episodesCollectionViewDataSource: EpisodesCollectionViewDataSource? {
        get { episodesCollectionView.dataSource }
        set { episodesCollectionView.dataSource = newValue }
    }

    var isLoading: Bool {
        get { episodesCollectionView.isLoading }
        set { episodesCollectionView.isLoading = newValue }
    }

    private lazy var episodesCollectionView = EpisodesCollectionView()
    private lazy var topGradientView = GradientView()

    private lazy var episodesCollectionViewWidthConstraint =
        episodesCollectionView.widthAnchor.constraint(equalToConstant: 0)

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(episodesCollectionView)
        contentView.addSubview(topGradientView)

        episodesCollectionView.pin(to: self, priority: .highest)
        topGradientView.pin(edges: [.left, .right, .top])

        NSLayoutConstraint.activate([
            episodesCollectionViewWidthConstraint,
            topGradientView.heightAnchor.constraint(equalToConstant: .standardSpacing * 2),
        ])

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {

        episodesCollectionViewWidthConstraint.constant = targetSize.width
        episodesCollectionView.layoutIfNeeded()
        return CGSize(width: targetSize.width, height: episodesCollectionView.contentSize.height)
    }

    func reloadVisibleItems() {
        episodesCollectionView.reloadVisibleItems()
    }
}

extension EpisodesTableViewCell: Themeable {
    func apply(theme: Theme) {
        topGradientView.colors = [theme.colors.backgroundPrimary, theme.colors.backgroundClear]
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}
