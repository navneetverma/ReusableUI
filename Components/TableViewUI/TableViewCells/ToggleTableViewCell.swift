//
//  ToggleTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/11/19.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Table view cell with UISwitch
public class ToggleTableViewCell: TableViewCell, Toggleable {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var state: ToggleState? {
        didSet {
            stateLabel.styledText = state?()
        }
    }

    public var rowSubview: RowSubview? {
        didSet {
            stackView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }
            (rowSubview?.makeView()).map {
                stackView.addArrangedSubview($0)
                stackView.addArrangedSubview(UIStackView())
            }
        }
    }

    public var toggleAction: ToggleAction?

    public private(set) lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.setContentCompressionResistancePriority(.required, for: .horizontal)
        toggle.isAccessibilityElement = false
        toggle.onTintColor = UIColor.SS.Slate.base
        toggle.addTarget(self, action: #selector(toggleValueDidChange), for: .valueChanged)
        return toggle
    }()

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel(style: .body4)
        label.numberOfLines = 0
        return label
    }()

    private lazy var stateLabel = UILabel(style: .body1)

    private lazy var topStackView: UIStackView = {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, stateLabel, toggle])
        titleStackView.alignment = .center
        titleStackView.spacing = 8
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        return titleStackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    public override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set { }
    }

    public override var accessibilityValue: String? {
        get {
            return toggle.isOn ? "On" : "Off"
        }
        set { }
    }

    public override var accessibilityHint: String? {
        get {
            return "Double tap to toggle setting"
        }
        set { }
    }

    public override func accessibilityActivate() -> Bool {
        toggle.setOn(!toggle.isOn, animated: true)
        return true
    }

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
        toggleAction = nil
        toggle.isOn = false
        title = nil
        state = nil
    }

    // MARK: - Actions

    @objc private func toggleValueDidChange(_ toggle: UISwitch) {
        toggleAction?(toggle.isOn)
        stateLabel.text = state?()
    }

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 12)
        contentView.addSubview(stackView)

        // Set one of the vertical constraints to lower than required priority to prevent (benign) layout error spew
        // during cell resizing. Strictly specifying vertical layout can conflict with the "encapsulated height" of the cell.
        let bottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            bottomConstraint
        ])
    }

    // MARK: - Toggleable

    public func toggleValue() {
        toggle.setOn(!toggle.isOn, animated: true)
        toggleAction?(toggle.isOn)
        stateLabel.text = state?()
    }
}

#endif
