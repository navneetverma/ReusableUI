//
//  MilestoneBubbleView.swift
//  
//
//  Created by Maxamilian Litteral on 1/5/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class MilestoneBubbleView: UIView {

    // MARK: - Properties

    private enum Constants {
        /// Tint color is used for icon and text
        static let completeTintColor = UIColor.SS.Blue.base
        static let completeBackgroundColor = UIColor.SS.Blue.base.withAlphaComponent(0.1)
        /// Tint color is used for icon and text
        static let incompleteTintColor = UIColor.SS.Grey.medium
        static let incompleteBackgroundColor = UIColor.SS.Grey.medium.withAlphaComponent(0.1)
    }

    /**
     true:
     - Blue background & text
     - Checkmark on top right
     false:
     - Grey background & text
     - No checkmark
     */
    var isCompleted: Bool = false {
        didSet {
            updateColors()
        }
    }

    var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    var body: String? {
        didSet {
            bodyLabel.styledText = body
        }
    }

    var icon: UIImage? {
        didSet {
            imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        }
    }

    /// Pill shaped background
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.bonMotStyle = .body2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.bonMotStyle = .body4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// Checkmark that appears in the top right if completed
    private lazy var completedIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "MilestoneCompleteIcon", in: .module, compatibleWith: nil))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// - Parameters:
    ///   - title: Title text that appears above the body
    ///   - body: Body text that appears below the title
    ///   - icon: Optional icon that appears to the left of the text
    ///   - completed: Completed milestones are blue with a checkmark, uncompleted milestones are grey
    public init(title: String?, body: String? = nil, icon: UIImage? = nil, completed: Bool) {
        self.isCompleted = completed
        self.title = title
        self.body = body
        self.icon = icon
        super.init(frame: .zero)
        self.titleLabel.styledText = title
        self.bodyLabel.styledText = body
        self.imageView.image = icon?.withRenderingMode(.alwaysTemplate)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = bounds.height / 2
    }

    // MARK: - Actions

    private func setup() {
        addSubview(backgroundView)
        addSubview(completedIcon)

        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        labelsStackView.alignment = .leading
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 3
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelsStackView)

        addSubview(imageView)

        // Fallback constraint
        let minimumHeightConstraint = backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        minimumHeightConstraint.priority = .required

        // This constraint will be used if possible
        let defaultHeightConstraint = backgroundView.heightAnchor.constraint(equalToConstant: 85)
        defaultHeightConstraint.priority = UILayoutPriority(500)

        NSLayoutConstraint.activate([
            minimumHeightConstraint, defaultHeightConstraint,

            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 67),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: labelsStackView.leadingAnchor, constant: -8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            completedIcon.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            completedIcon.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            completedIcon.heightAnchor.constraint(equalToConstant: 23),
            completedIcon.widthAnchor.constraint(equalTo: completedIcon.heightAnchor)
        ])

        updateColors()
    }

    private func updateColors() {
        backgroundView.backgroundColor = isCompleted ? Constants.completeBackgroundColor : Constants.incompleteBackgroundColor
        let tintColor = isCompleted ? Constants.completeTintColor : Constants.incompleteTintColor
        titleLabel.bonMotStyle?.color = tintColor
        bodyLabel.bonMotStyle?.color = tintColor
        imageView.tintColor = tintColor
        completedIcon.isHidden = !isCompleted
    }
}

#endif
