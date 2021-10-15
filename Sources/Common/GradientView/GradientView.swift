import UIKit

public class GradientView: UIView {
    public var colors: [UIColor] = [] {
        didSet { gradientLayer?.colors = colors.map { $0.cgColor } }
    }

    public var startPoint: CGPoint {
        get { gradientLayer?.startPoint ?? .zero }
        set { gradientLayer?.startPoint = newValue }
    }

    public var endPoint: CGPoint {
        get { gradientLayer?.endPoint ?? .zero }
        set { gradientLayer?.endPoint = newValue }
    }

    public override class var layerClass: AnyClass { CAGradientLayer.self }
}

private extension GradientView {
    var gradientLayer: CAGradientLayer? { layer as? CAGradientLayer }
}
