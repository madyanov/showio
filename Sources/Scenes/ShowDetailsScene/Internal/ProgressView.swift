import UIKit
import ConstraintLayout
import ProgressBarView
import Styling

final class ProgressView: UIView {
    var spacing: CGFloat = .standardSpacing {
        didSet { updateUI() }
    }

    var progressBarHeight: CGFloat = .standardSpacing {
        didSet { updateUI() }
    }

    var showLabels = true {
        didSet { updateUI() }
    }

    var leadingLabelText: String? {
        didSet { updateUI() }
    }

    var trailingLabelText: String? {
        didSet { updateUI() }
    }

    var progress: Float = 0 {
        didSet { updateUI() }
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .standardSpacing
        return stackView
    }()

    private lazy var leadingLabel = UILabel()

    private lazy var trailingLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var progressBarView = ProgressBarView()

    init() {
        super.init(frame: .zero)

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(labelsStackView)
        labelsStackView.addArrangedSubview(leadingLabel)
        labelsStackView.addArrangedSubview(trailingLabel)
        contentStackView.addArrangedSubview(progressBarView)

        contentStackView.pin()

        updateUI()
        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setProgress(_ progress: Float, animated: Bool = false) {
        progressBarView.setProgress(progress, animated: animated)
    }
}

extension ProgressView: Themeable {
    func apply(theme: Theme) {
        leadingLabel.textColor = theme.colors.foregroundSecondary
        trailingLabel.textColor = theme.colors.foregroundSecondary
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension ProgressView {
    func updateUI() {
        contentStackView.spacing = spacing
        progressBarView.height = progressBarHeight

        leadingLabel.isHidden = !showLabels
        trailingLabel.isHidden = !showLabels

        leadingLabel.text = leadingLabelText
        trailingLabel.text = trailingLabelText

        progressBarView.progress = progress
    }
}
