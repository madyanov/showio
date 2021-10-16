import UIKit
import Styling

final class LoadingTableViewCell: UITableViewCell {
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.center()

        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {

        var targetSize = targetSize
        targetSize.height = traitCollection.verticalSizeClass == .regular ? 400 : 200
        return targetSize
    }
}

extension LoadingTableViewCell: Themeable {
    func apply(theme: Theme) {
        activityIndicatorView.style = theme.styles.activityIndicator
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}
