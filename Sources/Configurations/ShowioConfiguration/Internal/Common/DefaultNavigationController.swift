import UIKit

final class DefaultNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? { topViewController }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
