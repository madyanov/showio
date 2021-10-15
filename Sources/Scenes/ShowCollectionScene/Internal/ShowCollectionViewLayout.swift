import UIKit

final class ShowCollectionViewLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {

        let layoutAttributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy()
            as? UICollectionViewLayoutAttributes
        updateLayoutAttributes(layoutAttributes)
        return layoutAttributes
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {

        let layoutAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy()
            as? UICollectionViewLayoutAttributes
        updateLayoutAttributes(layoutAttributes)
        return layoutAttributes
    }

    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        let invalidationContext = context as? UICollectionViewFlowLayoutInvalidationContext
        invalidationContext?.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }
}

private extension ShowCollectionViewLayout {
    func updateLayoutAttributes(_ layoutAttributes: UICollectionViewLayoutAttributes?) {
        layoutAttributes?.alpha = 0
        layoutAttributes?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
}
