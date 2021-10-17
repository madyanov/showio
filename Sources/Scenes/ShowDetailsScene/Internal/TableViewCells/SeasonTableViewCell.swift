import UIKit
import ConstraintLayout
import Styling

final class SeasonTableViewCell: UITableViewCell {
    struct Season {
        let progress: Float
        let number: Int
        let name: String?
        let numberOfViewedEpisodes: Int
        let numberOfEpisodes: Int
    }

    var viewButtonTapHandler: ((ViewButton.State) -> Void)? {
        didSet { updateUI() }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .standardSpacing * 2
        return stackView
    }()

    private lazy var viewButton = ViewButton()
    private lazy var progressView = ProgressView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(viewButton)
        stackView.addArrangedSubview(progressView)

        stackView.pin(edges: .vertical(.standardSpacing * 2) + .horizontal(.standardSpacing * 3))

        updateUI()
    }

    func setSeason(_ season: Season?, animated: Bool = false) {
        viewButton.state = (season?.progress).map { .viewed($0 == 1) } ?? .hidden

        guard let season = season else {
            progressView.setProgress(0, animated: animated)
            progressView.showLabels = false
            return
        }

        let seasonName = season.name ?? "Season %d".localized(comment: "Default season name", season.number)
        progressView.leadingLabelText = "\(season.number). \(seasonName)"
        progressView.trailingLabelText = "\(season.numberOfViewedEpisodes)/\(season.numberOfEpisodes)"
        progressView.setProgress(season.progress, animated: animated)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SeasonTableViewCell {
    func updateUI() {
        viewButton.tapHandler = viewButtonTapHandler
    }
}
