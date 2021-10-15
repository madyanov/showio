import UIKit

public struct Style {
    public struct Colors {
        public let backgroundClear: UIColor
        public let backgroundPrimary: UIColor
        public let backgroundSecondary: UIColor
        public let foregroundPrimary: UIColor
        public let foregroundSecondary: UIColor
        public let brandPrimary: UIColor
        public let brandSecondary: UIColor
        public let rating: UIColor
        public let tint: UIColor
    }

    public struct Styles {
        public let blur: UIBlurEffect.Style
        public let statusBar: UIStatusBarStyle
        public let activityIndicator: UIActivityIndicatorView.Style
        public let keyboard: UIKeyboardAppearance
        public let scrollIndicator: UIScrollView.IndicatorStyle
    }

    public struct Fonts {
        public let largeTitle: UIFont
        public let title1: UIFont
        public let title2: UIFont
        public let title3: UIFont
        public let headline: UIFont
        public let subheadline: UIFont
        public let body: UIFont
        public let callout: UIFont
        public let footnote: UIFont
        public let caption1: UIFont
        public let caption2: UIFont
    }

    public let colors: Colors
    public let styles: Styles
    public let fonts: Fonts
}
