import UIKit
import ConstraintLayout
import GradientView
import Styling

public final class ProgressBarView: UIView {
    public var progress: Float = 0 {
        didSet { setNeedsLayout() }
    }

    public var height: CGFloat = 4 {
        didSet { updateUI() }
    }

    public var shouldRoundCorners = true {
        didSet { updateUI() }
    }

    private lazy var filledView: GradientView = {
        let gradientView = GradientView()
        gradientView.layer.masksToBounds = true
        gradientView.startPoint = CGPoint(x: 0, y: 0.5)
        gradientView.endPoint = CGPoint(x: 1, y: 0.5)
        return gradientView
    }()

    private lazy var filledViewWidthConstraint = filledView.widthAnchor.constraint(equalToConstant: 0)

    private var cornerRadius: CGFloat {
        return shouldRoundCorners ? height / 2 : 0
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    public init() {
        super.init(frame: .zero)
        layer.masksToBounds = true

        addSubview(filledView)

        filledViewWidthConstraint.isActive = true
        filledView.pin(edges: [.top, .bottom, .leading])

        updateUI()
        themeProvider.register(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        filledViewWidthConstraint.constant = bounds.width * CGFloat(progress)
    }

    public func setProgress(_ progress: Float, animated: Bool = false) {
        self.progress = progress
        guard animated else { return }

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        })
    }
}

extension ProgressBarView: Themeable {
    public func apply(theme: Theme) {
        filledView.colors = [theme.colors.brandPrimary, theme.colors.brandSecondary]
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension ProgressBarView {
    func updateUI() {
        layer.cornerRadius = cornerRadius
        filledView.layer.cornerRadius = cornerRadius
    }
}
