//
//  MultipleChoiceView.swift
//  
//
//  Created by Rob Visentin on 11/13/20.
//

#if canImport(UIKit)
import UIKit

public typealias MultipleChoiceOption = LocalizedStringConvertible & Equatable

public class MultipleChoiceView<T: MultipleChoiceOption>: UIControl {

    // MARK: - Properties

    public var options: [T] {
        didSet {
            _selectedOptions = _selectedOptions.filter(options.contains)
            rebuildButtons()
        }
    }

    public var selectedOptions: [T] {
        get {
            return _selectedOptions
        }
        set {
            let oldValue = _selectedOptions
            let newValue = newValue.filter(options.contains)

            _selectedOptions = newValue
            updateButtonStates()

            if oldValue != newValue {
                sendActions(for: .valueChanged)
            }
        }
    }

    public var allowsMultipleSelection: Bool {
        didSet {
            if oldValue && !allowsMultipleSelection {
                selectedOptions = Array(selectedOptions.prefix(1))
            }
        }
    }

    public var buttonFont: UIFont? {
        didSet {
            buttons.forEach { $0.titleLabel?.font = buttonFont }
        }
    }

    public var buttonSpacing: CGFloat {
        get {
            return buttonStack.spacing
        }
        set {
            buttonStack.spacing = newValue
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateButtonStates()
        }
    }

    private let buttonStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        return view
    }()

    private var buttons: [UIButton] {
        return buttonStack.arrangedSubviews.compactMap { $0 as? UIButton }
    }

    private var _selectedOptions = [T]()

    // MARK: - Lifecycle

    public init(options: [T] = [], allowsMultipleSelection: Bool = true) {
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection

        super.init(frame: .zero)

        setup()
        rebuildButtons()
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            buttonStack.topAnchor.constraint(equalTo: topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func makeButton(for option: T) -> UIButton {
        let button = MultipleChoiceButton()

        button.setTitle(option.localizedDescription, for: .normal)
        button.titleLabel?.font = buttonFont
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        return button
    }

    // MARK: - Actions

    private func rebuildButtons() {
        buttonStack.subviews.forEach { $0.removeFromSuperview() }
        options.map(makeButton).forEach(buttonStack.addArrangedSubview)

        // Constrain button width equally
        buttonStack.arrangedSubviews.dropFirst(1).forEach {
            $0.widthAnchor.constraint(equalTo: buttonStack.arrangedSubviews[0].widthAnchor).isActive = true
        }

        updateButtonStates()
    }

    private func updateButtonStates() {
        buttons.enumerated().forEach { idx, button in
            button.isEnabled = isEnabled
            button.isSelected = selectedOptions.contains(options[idx])

            if allowsMultipleSelection || selectedOptions.isEmpty {
                button.alpha = 1
            } else {
                button.alpha = (button.isSelected ? 1 : 0.6)
            }
        }
    }

    @objc private func buttonPressed(sender: UIButton) {
        guard let idx = buttons.firstIndex(of: sender) else {
            return
        }

        let option = options[idx]

        if selectedOptions.contains(option) {
            selectedOptions = selectedOptions.filter { $0 != option }
        } else if allowsMultipleSelection {
            selectedOptions.append(option)
        } else {
            selectedOptions = [option]
        }
    }

}

// MARK: - MultipleChoiceButton

private class MultipleChoiceButton: UIButton {

    private static let image = UIImage.colored(UIColor.SS.Grey.white)
    private static let highlightedImage = UIImage.colored(UIColor.SS.Grey.light)
    private static let selectedImage = UIImage.colored(UIColor.SS.Slate.base)
    private static let selectedHighlightedImage = UIImage.colored(UIColor.SS.Slate.dark)

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width = max(44, size.width)
        size.height = max(44, size.height)
        return size
    }

    init() {
        super.init(frame: .zero)

        contentEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)

        layer.borderColor = UIColor.SS.Slate.base.cgColor
        layer.borderWidth = 1

        setBackgroundImage(MultipleChoiceButton.image, for: .normal)
        setBackgroundImage(MultipleChoiceButton.highlightedImage, for: .highlighted)
        setBackgroundImage(MultipleChoiceButton.selectedImage, for: .selected)
        setBackgroundImage(MultipleChoiceButton.selectedHighlightedImage, for: [.selected, .highlighted])

        setTitleColor(UIColor.SS.Slate.base, for: .normal)
        setTitleColor(UIColor.SS.Grey.white, for: .selected)
        setTitleColor(UIColor.SS.Grey.white, for: [.selected, .highlighted])

        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)

        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 0.5 * min(bounds.width, bounds.height)
        layer.masksToBounds = true
    }

}
#endif
