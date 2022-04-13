//
//  RadioGroupView.swift
//  
//
//  Created by Rob Visentin on 1/21/21.
//

#if canImport(UIKit)
import UIKit

public class RadioGroupView<Option: Equatable & RadioOptionConvertible, Container: UIView & RadioOptionContainer>: UIControl {

    // MARK: - Properties

    public let axis: NSLayoutConstraint.Axis
    public let alignment: UIStackView.Alignment

    public var options: [Option] {
        didSet {
            if let selectedOption = selectedOption, !options.contains(selectedOption) {
                _selectedOption = nil
            }
            rebuildButtons()
        }
    }

    public var selectedOption: Option? {
        get {
            _selectedOption
        }
        set {
            let oldValue = _selectedOption
            _selectedOption = newValue

            updateButtonStates()

            if oldValue != newValue {
                sendActions(for: .valueChanged)
            }
        }
    }

    public var spacing: CGFloat {
        get {
            containerStack.spacing
        }
        set {
            containerStack.spacing = newValue
        }
    }

    public override var isEnabled: Bool {
        didSet {
            contentView.isUserInteractionEnabled = isEnabled
            contentView.alpha = (isEnabled ? 1 : 0.6)
        }
    }

    private lazy var contentView: ScrollingStackView = {
        let contentView = ScrollingStackView(axis: axis, alignment: alignment, spacing: 16)
        contentView.content.isLayoutMarginsRelativeArrangement = true
        contentView.content.layoutMargins = layoutMargins
        return contentView
    }()

    private var containerStack: UIStackView {
        contentView.content
    }

    private var containers: [Container] {
        containerStack.arrangedSubviews.compactMap { $0 as? Container }
    }

    private var _selectedOption: Option?

    // MARK: - Lifecycle

    public init<T: Collection>(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .center, options: T) where T.Element == Option {
        self.axis = axis
        self.alignment = alignment
        self.options = Array(options)

        super.init(frame: .zero)

        setup()
        rebuildButtons()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        containerStack.layoutMargins = layoutMargins
    }

    // MARK: - Setup

    private func setup() {
        layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

        addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualTo: contentView.content.heightAnchor)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }

    private func makeContainer(for option: Option) -> Container {
        let container = Container()

        container.configure(with: option)
        container.toggleAction = { [weak self] selected in
            if selected {
                self?.selectedOption = option
            } else if option == self?.selectedOption {
                self?.selectedOption = nil
            }
        }

        return container
    }

    // MARK: - Actions

    private func rebuildButtons() {
        containerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        options.map(makeContainer).forEach(containerStack.addArrangedSubview)
        updateButtonStates()
    }

    private func updateButtonStates() {
        containers.enumerated().forEach { idx, container in
            container.isToggleSelected = (selectedOption == options[idx])
        }
    }

}

public extension RadioGroupView where Option: CaseIterable {

    @nonobjc convenience init(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .center) {
        self.init(axis: axis, alignment: alignment, options: Option.allCases)
    }

}

#endif
