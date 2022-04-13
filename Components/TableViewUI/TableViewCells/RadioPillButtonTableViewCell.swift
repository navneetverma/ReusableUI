//
//  RadioPillButtonTableViewCell.swift
//  
//
//  Created by Rob Visentin on 1/20/21.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with detail text on the right
public class RadioPillButtonTableViewCell: TableViewCell, RadioOptionContainer {

    // MARK: - Properties

    public var title: String? {
        get {
            radioButton.title(for: .normal)
        }
        set {
            radioButton.setTitle(newValue, for: .normal)
        }
    }

    public var toggleAction: ToggleAction? {
        get {
            radioButton.toggleAction
        }
        set {
            radioButton.toggleAction = newValue
        }
    }

    public var isToggleSelected: Bool {
        get {
            radioButton.isToggleSelected
        }
        set {
            radioButton.isToggleSelected = newValue
        }
    }

    private lazy var radioButton: RadioPillButton = {
        let button = RadioPillButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        isToggleSelected = false
        toggleAction = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            radioButton.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            radioButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            radioButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    // MARK: - RadioOptionContainer

    public func toggleValue() {
        radioButton.toggleValue()
    }

    public func configure(with option: RadioOptionConvertible) {
        title = option.title
    }

}

#endif

