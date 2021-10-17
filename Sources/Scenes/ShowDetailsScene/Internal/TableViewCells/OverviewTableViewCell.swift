import UIKit
import ConstraintLayout
import CollapsingTextView

final class OverviewTableViewCell: UITableViewCell {
    var text: String? {
        didSet { updateUI() }
    }

    var isCollapsed: Bool = true {
        didSet { updateUI() }
    }

    var readMoreButtonTapHandler: (() -> Void)? {
        didSet { updateUI() }
    }

    private lazy var overviewText = CollapsingTextView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(overviewText)
        overviewText.pin(edges: .vertical(.standardSpacing * 2) + .horizontal(.standardSpacing * 3))

        updateUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OverviewTableViewCell {
    func updateUI() {
        overviewText.text = text
        overviewText.isCollapsed = isCollapsed
        overviewText.readMoreButtonTapHandler = readMoreButtonTapHandler
    }
}
