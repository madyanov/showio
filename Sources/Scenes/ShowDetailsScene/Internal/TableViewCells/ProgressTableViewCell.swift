import UIKit
import ConstraintLayout
import Localization

final class ProgressTableViewCell: UITableViewCell {
    struct Show {
        let progress: Float
        let numberOfViewedEpisodes: Int
        let numberOfEpisodes: Int
    }

    private lazy var progressView: ProgressView = {
        let progressView = ProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leadingLabelText = "Total progress".localized(comment: "Total progress label")
        return progressView
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(progressView)
        progressView.pin(edges: .vertical(.standardSpacing * 2) + .horizontal(.standardSpacing * 3))
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // todo: move to presenter
    func configure(with show: Show?, animated: Bool = false) {
        progressView.setProgress(show?.progress ?? 0, animated: animated)
        progressView.trailingLabelText = show.map { "\($0.numberOfViewedEpisodes)/\($0.numberOfEpisodes)" }
    }
}
