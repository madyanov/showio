import UIKit

public final class CollapsingTextView: UIView {
    public var readMoreButtonTapHandler: (() -> Void)?

    public var isCollapsed = true {
        didSet { updateUI() }
    }

    public var collapsedNumberOfLines = 3 {
        didSet { updateUI() }
    }

    public var hasReadMoreButton = false {
        didSet { updateUI() }
    }

    public var text: String? {
        didSet { updateUI() }
    }

    public var readMoreButtonTitle: String? {
        didSet { updateUI() }
    }

    public var readLessButtonTitle: String? {
        didSet { updateUI() }
    }

    public var textColor: UIColor? {
        didSet { updateUI() }
    }

    public var readMoreButtonColor: UIColor? {
        didSet { updateUI() }
    }

    public var textFont: UIFont? {
        didSet { updateUI() }
    }

    public var readMoreButtonTitleFont: UIFont? {
        didSet { updateUI() }
    }

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .top
        label.setContentCompressionResistancePriority(.highest, for: .vertical)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReadMoreButton)))
        return label
    }()

    private lazy var readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setContentCompressionResistancePriority(.highest, for: .vertical)
        button.setContentHuggingPriority(.highest, for: .vertical)
        button.addTarget(self, action: #selector(didTapReadMoreButton), for: .touchUpInside)
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .leading
        return button
    }()

    public init() {
        super.init(frame: .zero)

        addSubview(contentStackView)
        contentStackView.addArrangedSubview(textLabel)
        contentStackView.addArrangedSubview(readMoreButton)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        updateUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CollapsingTextView {
    func updateUI() {
        textLabel.text = text
        textLabel.isUserInteractionEnabled = !hasReadMoreButton

        readMoreButton.isHidden = !hasReadMoreButton

        if isCollapsed {
            textLabel.numberOfLines = collapsedNumberOfLines
            readMoreButton.setTitle(readMoreButtonTitle, for: .normal)
        } else {
            textLabel.numberOfLines = 0
            readMoreButton.setTitle(readLessButtonTitle, for: .normal)
        }

        textLabel.font = textFont ?? .preferredFont(forTextStyle: .body)
        textLabel.textColor = textColor ?? .black

        readMoreButton.titleLabel?.font = readMoreButtonTitleFont ?? .preferredFont(forTextStyle: .body)
        readMoreButton.setTitleColor(.systemBlue, for: .normal)
    }

    @objc
    func didTapReadMoreButton() {
        isCollapsed.toggle()
        readMoreButtonTapHandler?()
    }
}

private extension UILayoutPriority {
    static let highest = UILayoutPriority(999)
}
