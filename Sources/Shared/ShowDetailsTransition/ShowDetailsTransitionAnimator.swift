import UIKit

public final class ShowTransitionAnimator: NSObject {
    private typealias ViewControllerAnimatingSubviews = UIViewController & ShowDetailsTransitionSubviewsAnimating

    public var maximumRegularWidth: CGFloat = 700

    public var minimumInsets = UIEdgeInsets(top: .standardSpacing * 2,
                                            left: .standardSpacing * 10,
                                            bottom: 0,
                                            right: .standardSpacing * 10)

    private var isPresentation = false
}

extension ShowTransitionAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresentation ? 0.5 : 0.3
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresentation {
            animatePresentation(using: transitionContext)
        } else {
            animateDismission(using: transitionContext)
        }
    }
}

extension ShowTransitionAnimator: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        isPresentation = true
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = false
        return self
    }

    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {

        return ShowPresentationController(presentedViewController: presented,
                                          presenting: presenting,
                                          maximumRegularWidth: maximumRegularWidth,
                                          minimumInsets: minimumInsets)
    }
}

private extension ShowTransitionAnimator {
    func animatePresentation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toView = transitionContext.view(forKey: .to),
            let toViewController = transitionContext.viewController(forKey: .to) as? ViewControllerAnimatingSubviews,
            let fromNavigationController = transitionContext.viewController(forKey: .from) as? UINavigationController,
            let fromViewController = fromNavigationController.topViewController as? ViewControllerAnimatingSubviews
        else {
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toViewController)

        containerView.addSubview(toView)
        toView.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.size.height)
        toView.layoutIfNeeded()

        let snapshots = initializeAnimatedSnapshots(containerView: containerView,
                                                    fromViewController: fromViewController,
                                                    toViewController: toViewController)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: []
        ) {
            toView.frame = finalFrame
            self.animateSnapshots(snapshots, containerView: containerView, toViewController: toViewController)
        } completion: { _ in
            self.cleanupSnapshots(snapshots, toViewController: toViewController) { finished in
                transitionContext.completeTransition(finished)
            }
        }
    }

    func animateDismission(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let fromViewController = transitionContext.viewController(forKey: .from)
                as? ViewControllerAnimatingSubviews,
            let toNavigationController = transitionContext.viewController(forKey: .to) as? UINavigationController,
            let toViewController = toNavigationController.topViewController as? ViewControllerAnimatingSubviews
        else {
            return
        }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: fromViewController)
        fromView.frame = finalFrame

        let snapshots = initializeAnimatedSnapshots(containerView: containerView,
                                                    fromViewController: fromViewController,
                                                    toViewController: toViewController)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.size.height)
            self.animateSnapshots(snapshots, containerView: containerView, toViewController: toViewController)
        }, completion: { _ in
            self.cleanupSnapshots(snapshots, toViewController: toViewController) { finished in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        })
    }

    func initializeAnimatedSnapshots(containerView: UIView,
                                     fromViewController: ShowDetailsTransitionSubviewsAnimating,
                                     toViewController: ShowDetailsTransitionSubviewsAnimating) -> [UIView] {

        fromViewController.animatedSubviews.forEach { $0.alpha = 1 }
        toViewController.animatedSubviews.forEach { $0.alpha = 1 }

        guard !toViewController.animatedSubviews.isEmpty else { return [] }

        let snapshots = fromViewController.animatedSubviews.compactMap { subview -> UIView? in
            let snapshot = subview.snapshotView(afterScreenUpdates: false)
            snapshot?.frame = containerView.convert(subview.frame, from: subview.superview)
            return snapshot
        }

        guard !snapshots.isEmpty else { return [] }

        snapshots.forEach { containerView.addSubview($0) }
        fromViewController.animatedSubviews.forEach { $0.alpha = 0 }
        toViewController.animatedSubviews.forEach { $0.alpha = 0 }

        return snapshots
    }

    func animateSnapshots(_ snapshots: [UIView],
                          containerView: UIView,
                          toViewController: ShowDetailsTransitionSubviewsAnimating) {

        zip(snapshots, toViewController.animatedSubviews).forEach { snapshot, subview in
            snapshot.frame = containerView.convert(subview.frame, from: subview.superview)
        }
    }

    func cleanupSnapshots(_ snapshots: [UIView],
                          toViewController: ShowDetailsTransitionSubviewsAnimating,
                          completion: @escaping (Bool) -> Void) {

        toViewController.animatedSubviews.forEach { $0.alpha = 1 }
        snapshots.forEach { $0.alpha = 1 }

        UIView.animate(withDuration: 0.3) {
            snapshots.forEach { $0.alpha = 0 }
        } completion: { finished in
            snapshots.forEach { $0.removeFromSuperview() }
            completion(finished)
        }
    }
}
