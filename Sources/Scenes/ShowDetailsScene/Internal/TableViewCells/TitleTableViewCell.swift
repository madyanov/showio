import UIKit
import ConstraintLayout
import Styling

final class TitleTableViewCell: UITableViewCell {
    var title: String? {
        didSet { updateUI() }
    }

    private lazy var titleLabel = UILabel()
    private lazy var topLineView = UIView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)
        contentView.addSubview(topLineView)

        titleLabel.pin(edges: [.top(.standardSpacing * 2),
                               .left(.standardSpacing * 3),
                               .bottom(.standardSpacing),
                               .right(.standardSpacing * 3)])

        topLineView.pin(edges: [.leading(.standardSpacing * 3), .top])
        topLineView.pin(edges: [.trailing], to: self)

        NSLayoutConstraint.activate([
            topLineView.heightAnchor.constraint(equalToConstant: 0.5),
        ])

        updateUI()
        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleTableViewCell: Themeable {
    func apply(theme: Theme) {
        titleLabel.textColor = theme.colors.foregroundPrimary
        topLineView.backgroundColor = theme.colors.foregroundPrimary.withAlphaComponent(0.1)

        titleLabel.font = theme.fonts.title2
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension TitleTableViewCell {
    func updateUI() {
        titleLabel.text = title
    }
}
