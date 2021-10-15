import UIKit

public final class HighlightingButton: UIButton {
    public var hightlightedBackgroundColor: UIColor? {
        didSet { updateUI() }
    }

    public var disabledBackgroundColor: UIColor? {
        didSet { updateUI() }
    }

    public var highlightedAlpha: CGFloat = 1 {
        didSet { updateUI() }
    }

    public var defaultBackgroundColor: UIColor? {
        didSet { updateUI() }
    }

    public override var isHighlighted: Bool {
        didSet { updateUI() }
    }

    public override var isEnabled: Bool {
        didSet { updateUI() }
    }

    private var backgroundGradientLayer: CAGradientLayer?

    public convenience init() {
        self.init(type: .system)
        updateUI()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradientLayer?.frame = bounds
    }

    public func addGradient(colors: [UIColor],
                            startPoint: CGPoint = .zero,
                            endPoint: CGPoint = CGPoint(x: 1, y: 1)) {

        let gradientLayer = backgroundGradientLayer ?? CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        imageView.map { bringSubviewToFront($0) }
        backgroundGradientLayer = gradientLayer
    }

    public func removeGradient() {
        backgroundGradientLayer?.removeFromSuperlayer()
    }
}

private extension HighlightingButton {
    func updateUI() {
        backgroundColor = defaultBackgroundColor

        if isHighlighted {
            backgroundColor = hightlightedBackgroundColor ?? defaultBackgroundColor
            alpha = highlightedAlpha
        } else {
            backgroundColor = defaultBackgroundColor
            alpha = 1
        }

        if isEnabled {
            backgroundColor = defaultBackgroundColor
        } else {
            backgroundColor = disabledBackgroundColor ?? defaultBackgroundColor
        }
    }
}
