import UIKit
import Resources

public enum Theme: String {
    case dark
    case light

    public var colors: Style.Colors { style.colors }
    public var styles: Style.Styles { style.styles }
    public var fonts: Style.Fonts { style.fonts }
}

private extension Theme {
    var style: Style {
        switch self {
        case .dark:
            return Theme.darkStyle
        case .light:
            return Theme.lightStyle
        }
    }
}

// MARK: - Dark Style
private extension Theme {
    static let darkStyle = Style(
        colors: .init(backgroundClear: Colors.backgroundPrimaryDark.color.withAlphaComponent(0),
                      backgroundPrimary: Colors.backgroundPrimaryDark.color,
                      backgroundSecondary: Colors.backgroundSecondaryDark.color,
                      foregroundPrimary: Colors.foregroundPrimaryDark.color,
                      foregroundSecondary: Colors.foregroundSecondary.color,
                      brandPrimary: Colors.brandPrimary.color,
                      brandSecondary: Colors.brandSecondary.color,
                      rating: Colors.rating.color,
                      tint: Colors.tintDark.color),
        styles: .init(blur: .dark,
                      statusBar: .lightContent,
                      activityIndicator: .white,
                      keyboard: .dark,
                      scrollIndicator: .white),
        fonts: .init(largeTitle: .preferredFont(forTextStyle: .largeTitle),
                     title1: .preferredFont(forTextStyle: .title1),
                     title2: .preferredFont(forTextStyle: .title2),
                     title3: .preferredFont(forTextStyle: .title3),
                     headline: .preferredFont(forTextStyle: .headline),
                     subheadline: .preferredFont(forTextStyle: .subheadline),
                     body: .preferredFont(forTextStyle: .body),
                     callout: .preferredFont(forTextStyle: .callout),
                     footnote: .preferredFont(forTextStyle: .footnote),
                     caption1: .preferredFont(forTextStyle: .caption1),
                     caption2: .preferredFont(forTextStyle: .caption2)))
}

// MARK: - Light Style
private extension Theme {
    static let lightStyle = Style(
        colors: .init(backgroundClear: Colors.backgroundPrimaryLight.color.withAlphaComponent(0),
                      backgroundPrimary: Colors.backgroundPrimaryLight.color,
                      backgroundSecondary: Colors.backgroundSecondaryLight.color,
                      foregroundPrimary: Colors.foregroundPrimaryLight.color,
                      foregroundSecondary: Colors.foregroundSecondary.color,
                      brandPrimary: Colors.brandPrimary.color,
                      brandSecondary: Colors.brandSecondary.color,
                      rating: Colors.rating.color,
                      tint: Colors.tintLight.color),
        styles: .init(blur: .extraLight,
                      statusBar: .default,
                      activityIndicator: .gray,
                      keyboard: .default,
                      scrollIndicator: .default),
        fonts: .init(largeTitle: .preferredFont(forTextStyle: .largeTitle),
                     title1: .preferredFont(forTextStyle: .title1),
                     title2: .preferredFont(forTextStyle: .title2),
                     title3: .preferredFont(forTextStyle: .title3),
                     headline: .preferredFont(forTextStyle: .headline),
                     subheadline: .preferredFont(forTextStyle: .subheadline),
                     body: .preferredFont(forTextStyle: .body),
                     callout: .preferredFont(forTextStyle: .callout),
                     footnote: .preferredFont(forTextStyle: .footnote),
                     caption1: .preferredFont(forTextStyle: .caption1),
                     caption2: .preferredFont(forTextStyle: .caption2)))
}
