import UIKit

public protocol RootFlowScreenFactory {
    func makeShowSearchScreen(showSelectHandler: @escaping (Int) -> Void) -> UIViewController
    func makeShowDetailsScreen() -> UIViewController
}
