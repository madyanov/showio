import UIKit
import ConstraintLayout
import Styling

public final class ShowDetailsView: UIView {
    public init() {
        super.init(frame: .zero)

        themeProvider.register(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShowDetailsView: Themeable {
    public func apply(theme: Theme) {
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}
