import UIKit

public enum Colors: String {
    case backgroundPrimaryDark
    case backgroundPrimaryLight
    case backgroundSecondaryDark
    case backgroundSecondaryLight
    case brandPrimary
    case brandSecondary
    case foregroundPrimaryDark
    case foregroundPrimaryLight
    case foregroundSecondary
    case rating
    case tintDark
    case tintLight

    public var color: UIColor {
        guard let color = UIColor(named: rawValue, in: .module, compatibleWith: nil) else {
            assertionFailure("Color \(rawValue) not found")
            return .clear
        }

        return color
    }
}
