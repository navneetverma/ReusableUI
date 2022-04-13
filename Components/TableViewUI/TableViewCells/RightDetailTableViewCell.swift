//
//  RightDetailTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/10/19.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Table view cell with detail text on the right
open class RightDetailTableViewCell: TableViewCell {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var subtitle: String? {
        didSet {
            subtitleLabel.styledText = subtitle
            subtitleLabel.isHidden = subtitle == nil
        }
    }

    public var detailText: String? {
        didSet {
            detailLabel.styledText = detailText
            detailLabel.isHidden = detailText == nil
        }
    }

    public var detailStyle: StringStyle? {
        get {
            detailLabel.bonMotStyle
        }
        set {
            detailLabel.bonMotStyle = newValue?.aligned(.right)
        }
    }

    public let detailLayoutGuide = UILayoutGuide()

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(style: .body4)
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(style: StringStyle.body1.aligned(.right))
        label.isHidden = true
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        subtitle = nil
        detailText = nil
        detailStyle = .body1
    }

    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        // This cell has inherent layout ambiguity because both the subtitle and detail labels support multiple lines
        // This resolves the ambiguity by defining max widths, though there be edge cases for which this isn't ideal.
        subtitleLabel.preferredMaxLayoutWidth = 0.5 * targetSize.width
        detailLabel.preferredMaxLayoutWidth = (targetSize.width - subtitleLabel.preferredMaxLayoutWidth)

        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.axis = .vertical
        titleStack.spacing = 4

        contentView.addSubview(titleStack)
        contentView.addSubview(detailLabel)
        contentView.addLayoutGuide(detailLayoutGuide)

        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleStack.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor, constant: -8),
            detailLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            detailLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            detailLayoutGuide.topAnchor.constraint(equalTo: detailLabel.topAnchor),
            detailLayoutGuide.leadingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
            detailLayoutGuide.bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor),
            detailLayoutGuide.trailingAnchor.constraint(equalTo: detailLabel.trailingAnchor)
        ])
    }
}

#endif

