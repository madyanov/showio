import UIKit

public enum Images: String {
    case checkmark
    case chevronDown
    case chevronLeft
    case clock
    case close
    case ellipsis
    case eye
    case flag
    case logo
    case nosign
    case plus
    case star

    public var image: UIImage {
        guard let image = UIImage(named: rawValue, in: .module, compatibleWith: nil) else {
            assertionFailure("Image \(rawValue) not found")
            return UIImage()
        }

        return image
    }
}
