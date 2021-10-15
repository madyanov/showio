import UIKit
import ConstraintLayout
import Styling

final class ShowPresentationController: UIPresentationController {
    private var maximumRegularWidth: CGFloat
    private var minimumInsets: UIEdgeInsets

    private lazy var blurredOverlayView = UIVisualEffectView(effect: nil)
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))

    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = super.frameOfPresentedViewInContainerView

        if traitCollection.horizontalSizeClass == .regular {
            let width = min(maximumRegularWidth, frame.size.width - minimumInsets.left - minimumInsets.right)
            frame.origin.x = (frame.size.width - width) / 2
            frame.origin.y = presentingViewController.view.safeAreaInsets.top + minimumInsets.top
            frame.size.width = width
            frame.size.height -= frame.origin.y
        }

        return frame
    }

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         maximumRegularWidth: CGFloat,
         minimumInsets: UIEdgeInsets) {

        self.maximumRegularWidth = maximumRegularWidth
        self.minimumInsets = minimumInsets

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        blurredOverlayView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(blurredOverlayView)
        blurredOverlayView.pin()

        let blurEffect = UIBlurEffect(style: themeProvider.theme.styles.blur)

        presentedViewController.transitionCoordinator?.animate { _ in
            self.blurredOverlayView.effect = blurEffect
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            blurredOverlayView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate { _ in
            self.blurredOverlayView.effect = nil
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blurredOverlayView.removeFromSuperview()
        }
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView

        if traitCollection.horizontalSizeClass == .regular {
            roundCornersAndAddShadow()
        } else {
            removeRoundedCornersAndShadow()
        }
    }
}

extension ShowPresentationController: Themeable {
    func apply(theme: Theme) { }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

private extension ShowPresentationController {
    func roundCornersAndAddShadow() {
        if let viewController = presentedViewController as? ViewCornersRounder {
            viewController.roundCorners()
        }

        if let viewController = presentedViewController as? ViewShader {
            viewController.addShadow()
        }
    }

    func removeRoundedCornersAndShadow() {
        if let viewController = presentedViewController as? ViewCornersRounder {
            viewController.removeRoundedCorners()
        }

        if let viewController = presentedViewController as? ViewShader {
            viewController.removeShadow()
        }
    }

    @objc
    func didTap() {
        presentingViewController.dismiss(animated: true)
    }
}
