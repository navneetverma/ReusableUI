//
//  SubtitleTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/10/19.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with detail text on the right
open class SubtitleTableViewCell: TableViewCell {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var subtitle: String? {
        didSet {
            subtitleLabel.styledText = subtitle
        }
    }

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(style: .body4)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        subtitle = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

#endif


