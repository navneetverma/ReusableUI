//
//  TableViewCardToggleCell.swift
//  
//
//  Created by Maxamilian Litteral on 10/21/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

/// "Show More" / "Show Less" button
final class TableViewCardToggleCell: UITableViewCell {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // MARK: - Actions

    func configure(title: String) {
        titleLabel.text = title
    }

    // MARK: Setup

    private func setup() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
}

#endif
