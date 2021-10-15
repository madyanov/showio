import UIKit
import Resources
import Styling
import ShowSearchScene

final class ShowSearchViewController: UIViewController {
    var searchQueryUpdateHandler: ((String?) -> Void)?

    var poweredByLinkTapHandler: (() -> Void)? {
        get { searchView.poweredByLinkTapHandler }
        set { searchView.poweredByLinkTapHandler = newValue }
    }

    private lazy var searchView: ShowSearchView = {
        let searchView = ShowSearchView()
        searchView.dataSource = dataSource
        return searchView
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        themeProvider.theme.styles.statusBar
    }

    private let presenter: ShowSearchPresenter
    private let dataSource: ShowSearchDataSource

    init(presenter: ShowSearchPresenter, dataSource: ShowSearchDataSource) {
        self.presenter = presenter
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true

        let backButtonSelector = #selector(UINavigationController.popViewController(animated:))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.chevronLeft.image,
                                                           style: .plain,
                                                           target: navigationController,
                                                           action: backButtonSelector)

        navigationItem.titleView = searchController.searchBar
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        presenter.didLoad(ui: self)
        themeProvider.register(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        transitionCoordinator?.animate { _ in
            self.searchView.showBlurredHeader()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // memory leak fix
        searchController.isActive = false

        transitionCoordinator?.animate { _ in
            self.searchView.hideBlurredHeader()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.showBlurredHeader()
        searchController.isActive = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.searchBar.text = nil
    }
}

extension ShowSearchViewController: Themeable {
    func apply(theme: Theme) {
        setNeedsStatusBarAppearanceUpdate()

        searchController.searchBar.tintColor = theme.colors.tint
        searchController.searchBar.keyboardAppearance = theme.styles.keyboard
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        themeProvider.changeThemeAccording(traitCollection)
    }
}

extension ShowSearchViewController: UIGestureRecognizerDelegate { }

extension ShowSearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        // workaround to show keyboard once view appeared
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }

        searchView.updatePoweredByLabelPosition()
    }
}

extension ShowSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchQueryUpdateHandler?(searchController.searchBar.text)
    }
}

extension ShowSearchViewController: ShowSearchUI {
    func reload() {
        searchView.reload()
    }

    func startActivityIndicator() {
        searchView.startActivityIndicator()
    }

    func stopActivityIndicator() {
        searchView.stopActivityIndicator()
    }
}
