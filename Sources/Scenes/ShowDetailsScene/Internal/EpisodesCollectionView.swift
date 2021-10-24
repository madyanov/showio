import UIKit
import ConstraintLayout
import Styling

enum EpisodesCollectionViewItem {
    case episode(EpisodeCollectionViewCell.Episode)
    case end(EndingCollectionViewCell.State)
}

protocol EpisodesCollectionViewDelegate: AnyObject {
    func episodesCollectionView(_ episodesCollectionView: EpisodesCollectionView,
                                didScrollFrom page: Int,
                                to newPage: Int)

    func initialPageIndex(in episodesCollectionView: EpisodesCollectionView) -> Int
}

protocol EpisodesCollectionViewDataSource: AnyObject {
    func numberOfItems(in episodesCollectionView: EpisodesCollectionView) -> Int

    func episodesCollectionView(_ episodesCollectionView: EpisodesCollectionView,
                                itemAt index: Int) -> EpisodesCollectionViewItem
}

final class EpisodesCollectionView: UIView {
    weak var delegate: EpisodesCollectionViewDelegate? {
        didSet {
            guard let initialPageIndex = delegate?.initialPageIndex(in: self) else { return }
            currentPageIndex = initialPageIndex
            updateScrollViewContentOffset()
        }
    }

    weak var dataSource: EpisodesCollectionViewDataSource?

    var contentSize: CGSize { collectionViewLayout.collectionViewContentSize }

    var isLoading = false {
        didSet {
            isUserInteractionEnabled = !isLoading

            if isLoading {
                overlayView.isHidden = false
                activityIndicatorView.startAnimating()

                UIView.animate(withDuration: 0.3) {
                    self.overlayView.alpha = 1
                }
            } else {
                overlayView.isHidden = false
                activityIndicatorView.stopAnimating()

                UIView.animate(withDuration: 0.3, animations: {
                    self.overlayView.alpha = 0
                }, completion: { _ in
                    self.overlayView.isHidden = true
                })
            }
        }
    }

    private(set) var currentPageIndex = 0

    private lazy var overlayView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        return view
    }()

    private lazy var activityIndicatorView = UIActivityIndicatorView()

    private lazy var collectionViewLayout: EpisodesCollectionViewLayout = {
        let collectionViewLayout = EpisodesCollectionViewLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = .standardSpacing * 2
        collectionViewLayout.minimumInteritemSpacing = .standardSpacing * 2
        return collectionViewLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addGestureRecognizer(scrollView.panGestureRecognizer)
        collectionView.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: episodeCellReuseIdentifier)
        collectionView.register(EndingCollectionViewCell.self, forCellWithReuseIdentifier: endingCellReuseIdentifier)
        return collectionView
    }()

    private lazy var scrollView: ScrollView = {
        let scrollView = ScrollView()
        scrollView.isHidden = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var sizingEpisodeCollectionViewCell = EpisodeCollectionViewCell()

    private var cachedItemSize: CGSize?

    private let episodeCellReuseIdentifier = "episodeCell"
    private let endingCellReuseIdentifier = "endingCell"

    private var itemWidth: CGFloat {
        collectionView.bounds.width - collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right
    }

    private var numberOfItems: Int { dataSource?.numberOfItems(in: self) ?? 0 }

    convenience init() {
        self.init(frame: .zero)

        addSubview(collectionView)
        addSubview(scrollView)
        addSubview(overlayView)
        overlayView.addSubview(activityIndicatorView)

        collectionView.pin()
        scrollView.pin()
        overlayView.pin()
        activityIndicatorView.center()

        themeProvider.register(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cachedItemSize = nil

        let additionalSectionInsets = traitCollection.horizontalSizeClass == .compact
            ? safeAreaInsets
            : .zero

        collectionViewLayout.sectionInset = UIEdgeInsets(top: .standardSpacing * 2,
                                                         left: additionalSectionInsets.left + .standardSpacing * 3,
                                                         bottom: .standardSpacing * 2,
                                                         right: additionalSectionInsets.right + .standardSpacing * 3)

        updateScrollViewContentSize()
        updateScrollViewContentOffset()
    }

    func reloadVisibleItems() {
        let oldCount = collectionView.numberOfItems(inSection: 0)
        let newCount = numberOfItems

        if oldCount < newCount {
            let indexPathsToInsert = (oldCount..<newCount).map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: indexPathsToInsert)
        } else if oldCount > newCount {
            let indexPathsToDelete = (newCount..<oldCount).map { IndexPath(item: $0, section: 0) }
            collectionView.deleteItems(at: indexPathsToDelete)
        }

        for cell in collectionView.visibleCells {
            guard let indexPath = collectionView.indexPath(for: cell) else { continue }
            configureCell(cell, at: indexPath)
        }

        if oldCount != newCount {
            updateScrollViewContentSize()
        }
    }
}

extension EpisodesCollectionView: Themeable {
    func apply(theme: Theme) {
        overlayView.backgroundColor = theme.colors.backgroundPrimary.withAlphaComponent(0.67)
        activityIndicatorView.style = theme.styles.activityIndicator
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
        collectionViewLayout.invalidateLayout()
        cachedItemSize = nil
    }
}

extension EpisodesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let size = cachedItemSize { return size }

        sizingEpisodeCollectionViewCell.configure(with: .sizing)

        let size = sizingEpisodeCollectionViewCell.contentView.systemLayoutSizeFitting(
            CGSize(width: itemWidth, height: 1),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )

        cachedItemSize = size
        return size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }

        let width = itemWidth + collectionViewLayout.minimumInteritemSpacing
        collectionView.contentOffset.x = scrollView.contentOffset.x * width / scrollView.bounds.width

        let newPageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)

        if scrollView.isDragging, newPageIndex != currentPageIndex {
            delegate?.episodesCollectionView(self, didScrollFrom: currentPageIndex, to: newPageIndex)
            currentPageIndex = newPageIndex
        }
    }
}

extension EpisodesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = dataSource?.episodesCollectionView(self, itemAt: indexPath.item)

        switch item {
        case .end:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: endingCellReuseIdentifier,
                                                          for: indexPath)
            configureCell(cell, with: item)
            return cell
        case .episode:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: episodeCellReuseIdentifier,
                                                          for: indexPath)
            configureCell(cell, with: item)
            return cell
        case .none:
            assertionFailure("Data source not set")
            return UICollectionViewCell()
        }
    }
}

private extension EpisodesCollectionView {
    func configureCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        let item = dataSource?.episodesCollectionView(self, itemAt: indexPath.item)
        configureCell(cell, with: item)
    }

    func configureCell(_ cell: UICollectionViewCell, with item: EpisodesCollectionViewItem?) {
        switch item {
        case .end(let state):
            let cell = cell as? EndingCollectionViewCell
            cell?.state = state
        case .episode(let episode):
            let cell = cell as? EpisodeCollectionViewCell
            cell?.configure(with: episode)
        case .none:
            break
        }
    }

    func updateScrollViewContentOffset() {
        scrollView.contentOffset.x = CGFloat(currentPageIndex) * scrollView.bounds.width
    }

    func scrollToPage(_ page: Int) {
        let contentOffset = CGPoint(x: scrollView.bounds.width * CGFloat(page), y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
        delegate?.episodesCollectionView(self, didScrollFrom: currentPageIndex, to: page)
        currentPageIndex = page
    }

    func updateScrollViewContentSize() {
        scrollView.contentSize = CGSize(
            width: CGFloat(collectionView.numberOfItems(inSection: 0)) * scrollView.bounds.width,
            height: bounds.height
        )
    }
}

private class ScrollView: UIScrollView {
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton { return true }
        return super.touchesShouldCancel(in: view)
    }
}

private extension EpisodeCollectionViewCell.Episode {
    static var sizing: Self {
        Self(stillURL: nil,
             showBackdropURL: nil,
             showPosterURL: nil,
             seasonNumber: 0,
             number: 0,
             name: "",
             overview: "\n\n",
             localizedAirDate: "",
             isViewed: false)
    }
}
