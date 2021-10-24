import UIKit
import ShowService

public protocol RootFlowScreenFactory {
    func makeShowSearchScreen(showSelectHandler: @escaping (Show.ID) -> Void) -> UIViewController
    func makeShowDetailsScreen() -> UIViewController
}
