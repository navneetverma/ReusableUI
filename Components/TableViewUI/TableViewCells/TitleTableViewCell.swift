//
//  TitleTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 1/2/20.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with detail text on the right
open class TitleTableViewCell: TableViewCell {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    private lazy var titleLabel = UILabel(style: .title2)

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 18)

        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

#endif
