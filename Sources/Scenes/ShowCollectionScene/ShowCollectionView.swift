import UIKit
import ConstraintLayout
import Localization
import Styling

public protocol ShowCollectionViewDataSource: AnyObject {
    func numberOfItems(in showCollectionView: ShowCollectionView) -> Int
    func showCollectionView(_ showCollectionView: ShowCollectionView, showForItemAt index: Int) -> ShowViewModel
    func showCollectionView(_ showCollectionView: ShowCollectionView, prefetchItemsAt indices: [Int])
}

extension ShowCollectionViewDataSource {
    public func showCollectionView(_ showCollectionView: ShowCollectionView, prefetchItemsAt indices: [Int]) { }
}

public final class ShowCollectionView: UIView {
    public weak var dataSource: ShowCollectionViewDataSource?

    public var additionalVerticalInset: CGFloat = 0 {
        didSet { themeProvider.reload(self) }
    }

    public var style = ShowCollectionStyle.default {
        didSet { sizingShowCollectionViewCell.style = style }
    }

    private lazy var collectionViewLayout = ShowCollectionViewLayout()

    private let showCellReuseIdentifier = "showCell"

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: showCellReuseIdentifier)
        return collectionView
    }()

    private lazy var sizingShowCollectionViewCell: ShowCollectionViewCell = {
        let showCollectionViewCell = ShowCollectionViewCell()
        showCollectionViewCell.style = style
        return showCollectionViewCell
    }()

    private var shouldScrollToTop = false
    private var cachedItemSize: CGSize?

    public init() {
        super.init(frame: .zero)

        addSubview(collectionView)

        collectionView.pin()

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let spacing: CGFloat = style == .minimal ? .defaultSpacing * 2 : .defaultSpacing * 3
        collectionViewLayout.minimumInteritemSpacing = spacing
        collectionViewLayout.minimumLineSpacing = spacing

        collectionViewLayout.sectionInset = UIEdgeInsets(top: spacing + additionalVerticalInset,
                                                         left: spacing,
                                                         bottom: spacing,
                                                         right: spacing)
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow != nil {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillChangeFrame),
                                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.removeObserver(self,
                                                      name: UIResponder.keyboardWillChangeFrameNotification,
                                                      object: nil)
        }
    }

    public func performBatchUpdates(_ updates: () -> Void) {
        collectionView.performBatchUpdates(updates) { _ in
            if self.shouldScrollToTop {
                self.scrollToTop()
                self.shouldScrollToTop = false
            }
        }
    }

    public func reloadData() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    public func insertItems(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
        shouldScrollToTop = indexPaths.contains { $0.item == 0 }
    }

    public func deleteItems(at indexPaths: [IndexPath]) {
        collectionView.deleteItems(at: indexPaths)
    }
}

extension ShowCollectionView: Themeable {
    public func apply(theme: Theme) {
        collectionView.indicatorStyle = theme.styles.scrollIndicator
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)

        cachedItemSize = nil
        collectionViewLayout.invalidateLayout()
    }
}

extension ShowCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               willDisplay cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {

        guard collectionView.isDragging else { return }

        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }

    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let show = dataSource?.showCollectionView(self, showForItemAt: indexPath.item) else {
            return false
        }

        UIMenuController.shared.menuItems = [
            UIMenuItem(title: "Delete".localized(comment: "Delete context menu item title"),
                       action: #selector(ShowCollectionViewCell.deleteAction)),
        ]

        let cell = collectionView.cellForItem(at: indexPath) as? ShowCollectionViewCell
        cell?.shouldCancelTapGesture = show.canDelete
        return show.canDelete
    }

    public func collectionView(_ collectionView: UICollectionView,
                               canPerformAction action: Selector,
                               forItemAt indexPath: IndexPath,
                               withSender sender: Any?) -> Bool {

        return action == #selector(ShowCollectionViewCell.deleteAction)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               performAction action: Selector,
                               forItemAt indexPath: IndexPath,
                               withSender sender: Any?) {

        // workaround to show menu
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let size = cachedItemSize {
            return size
        }

        configureCell(sizingShowCollectionViewCell, at: indexPath)

        let contentWidth = collectionView.bounds.width -
            self.collectionViewLayout.sectionInset.left -
            self.collectionViewLayout.sectionInset.right -
            collectionView.contentInset.left -
            collectionView.contentInset.right

        let sizeRatio = collectionView.bounds.height / collectionView.bounds.width
        var numberOfColumns: CGFloat = 0

        if traitCollection.userInterfaceIdiom == .pad {
            numberOfColumns = sizeRatio < 1 ? 5 : 4
        } else if style == .minimal {
            numberOfColumns = sizeRatio < 1 ? 5 : 3
        } else {
            numberOfColumns = sizeRatio < 1 ? 4 : 2
        }

        let interitemSpacing = self.collectionViewLayout.minimumInteritemSpacing
        let width = (contentWidth - interitemSpacing * (numberOfColumns - 1)) / numberOfColumns - 1

        let height = sizingShowCollectionViewCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: 1),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        let size = CGSize(width: width, height: height)
        cachedItemSize = size
        return size
    }
}

extension ShowCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: showCellReuseIdentifier, for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
}

extension ShowCollectionView: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataSource?.showCollectionView(self, prefetchItemsAt: indexPaths.map { $0.item })
    }
}

private extension ShowCollectionView {
    func configureCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard
            let cell = cell as? ShowCollectionViewCell,
            let show = dataSource?.showCollectionView(self, showForItemAt: indexPath.item)
        else {
            return
        }

        cell.style = style
        cell.configure(with: show)
    }

    func scrollToTop() {
        let offset = CGPoint(x: -collectionView.adjustedContentInset.left,
                             y: -collectionView.adjustedContentInset.top)

        collectionView.setContentOffset(offset, animated: true)
    }

    @objc
    func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let window = UIApplication.shared.windows.first,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }

        let keyboardHeight = window.bounds.height - keyboardFrame.minY
        collectionView.contentInset.bottom = keyboardHeight
        collectionView.scrollIndicatorInsets.bottom = keyboardHeight
    }
}
