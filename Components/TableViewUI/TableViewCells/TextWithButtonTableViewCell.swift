//
//  TextWithButtonTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/19/19.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with multiline label and button
public class TextWithButtonTableViewCell: TableViewCell {

    // MARK: - Properties

    public var bodyText: String? {
        didSet {
            bodyLabel.styledText = bodyText
        }
    }

    public var buttonText: String? {
        didSet {
            button.styledText = buttonText
        }
    }

    private var bodyLabel: UILabel = {
        let label = UILabel(style: .body1)
        label.numberOfLines = 0
        return label
    }()

    public var button: UIButton = {
        let button = UIButton()
        button.bonMotStyle = .link1
        button.isUserInteractionEnabled = false
        return button
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        bodyText = nil
        buttonText = nil
    }

    // MARK: - Actions

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        let stackView = UIStackView(arrangedSubviews: [bodyLabel, button])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8
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
