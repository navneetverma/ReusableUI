//
//  ToggleableTableViewCell.swift
//  
//
//  Created by Rob Visentin on 2/09/21.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with selectable button on the left and title + detail text on the right
open class ToggleableTableviewCell<ButtonType: UIButton>: TableViewCell, Toggleable {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var detailText: String? {
        didSet {
            detailLabel.styledText = detailText
        }
    }

    public var toggleAction: ToggleAction?

    public var isToggleSelected: Bool {
        get {
            button.isSelected
        }
        set {
            button.isSelected = newValue
        }
    }

    private lazy var button: ButtonType = {
        let button = ButtonType()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var detailLabel: UILabel = {
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
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        detailText = nil
        toggleAction = nil
        isToggleSelected = false
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 18)

        contentView.addSubview(button)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            button.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            stackView.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }

    // MARK: - Toggleable

    public func toggleValue() {
        isToggleSelected.toggle()
        toggleAction?(isToggleSelected)
    }
}

#endif

