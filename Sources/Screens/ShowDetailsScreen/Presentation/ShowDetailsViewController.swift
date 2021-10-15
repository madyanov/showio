import UIKit
import ShowDetailsScene

final class ShowDetailsViewController: UIViewController {
    private lazy var detailsView = ShowDetailsView()

    override func loadView() {
        view = detailsView
    }
}
