//
//  InputField.swift
//  
//
//  Created by Maxamilian Litteral on 3/9/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public struct InputFieldAppearance {
    /// Image that is shown when text is visible
    public let visibleIcon: UIImage?
    /// Image that is shown when text is invisible
    public let invisibleIcon: UIImage?

    public init(visibleIcon: UIImage?, invisibleIcon: UIImage?) {
        self.visibleIcon = visibleIcon
        self.invisibleIcon = invisibleIcon
    }
}

public protocol InputFieldDelegate: AnyObject {
    func textFieldTextDidChange(_ text: String?, from inputField: InputField)
    func canMoveToNextField(from: InputField) -> Bool
    func moveToNextField(after: InputField)
}

public class InputField: UIView, UITextFieldDelegate {

    // MARK: - Properties

    private enum Constants {
        static let defaultBorderColor = UIColor.SS.Grey.light
        static let activeBorderColor = UIColor.SS.Slate.base
        static let errorBorderColor = UIColor.SS.Red.light
        static let titleColor = UIColor.SS.Grey.medium
        static let visibilityToggleTitleHide = "Hide"
        static let visibilityToggleTitleShow = "Show"
    }

    public weak var delegate: InputFieldDelegate?

    public var title: String? {
        didSet {
            titleLabel.styledText = title
            titleLabel.isHidden = title == nil
        }
    }

    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.bonMotStyle = .body2
        textField.font = textField.bonMotStyle?.font
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            textField.overrideUserInterfaceStyle = .light
        }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        textField.setContentHuggingPriority(.required, for: .vertical)
        return textField
    }()

    public var currentValue: String? {
        textField.text
    }

    private lazy var textFieldSecureButtonToggle: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(textFieldSecureButtonTapped), for: .touchUpInside)
        // Fixes a bug where textField with long text will hide textFieldSecureButtonToggle, check UIStackView.Distribution.Fill docs
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.defaultLow, for: .vertical)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var textFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textField, textFieldSecureButtonToggle])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldSecureButtonToggle.heightAnchor.constraint(equalTo: textField.heightAnchor).isActive = true
        return stackView
    }()

    private lazy var textFieldContainer: UIView = {
        let view = TextFieldContainer()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.defaultBorderColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldStackView)

        NSLayoutConstraint.activate([
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textFieldStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            textFieldStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        return view
    }()

    private let titleLabel = UILabel(style: StringStyle.label1.colored(Constants.titleColor))

    private let errorLabel: UILabel = {
        let label = UILabel(style: StringStyle.message2.colored(Constants.errorBorderColor))
        label.numberOfLines = 0
        return label
    }()

    // MARK: Error handling
    /// Function that passes the current text value and returns if the text is valid or not.
    /// Returning a localized error will set the `temporaryError` value
    /// and display an error message below the text field.
    public var textValidationBlock: ((String?) -> Result<Void, Error>)?
    /// Error attached to a text field that does not clear automatically.
    /// This error has a higher priority over the `temporaryError` and will
    /// display this error until it is `nil`
    public var error: Error? {
        didSet {
            updateErrorState()
        }
    }
    /// Error attached to the text field that is cleared after input
    public var temporaryError: Error? {
        didSet {
            updateErrorState()
        }
    }

    /// Setting this value to `true` will automatically handle displaying buttons to toggle text field text visibility.
    public var isSecureEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = isSecureEntry
            textFieldSecureButtonToggle.isHidden = !isSecureEntry
            updateTextFieldSecureToggleButton()
        }
    }

    public var isTextVisible: Bool {
        return !textField.isSecureTextEntry
    }

    public var appearance: InputFieldAppearance? {
        didSet {
            updateTextFieldSecureToggleButton()
        }
    }

    public var characterLimit: Int?

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public init(title: String?, placeholder: String?, isSecureEntry: Bool = false, keyboardType: UIKeyboardType = .default, autocapitalizationType: UITextAutocapitalizationType = .none, autocorrectionType: UITextAutocorrectionType = .no) {
        self.title = title
        self.isSecureEntry = isSecureEntry
        super.init(frame: .zero)
        setup()
        titleLabel.styledText = title
        titleLabel.isHidden = title == nil
        textField.attributedPlaceholder = placeholder?.styled(with: StringStyle.body2.colored(UIColor.SS.Grey.light))
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecureEntry
        textField.autocapitalizationType = autocapitalizationType
        textField.autocorrectionType = autocorrectionType

        textFieldSecureButtonToggle.isHidden = !isSecureEntry
        updateTextFieldSecureToggleButton()
        self.tintColor = UIColor.SS.Slate.base
    }

    override public func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        _ = textField.becomeFirstResponder()
        return true
    }

    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        _ = textField.resignFirstResponder()
        return true
    }

    // MARK: - Actions

    @objc func textFieldDidChange(_ textField: UITextField) {
        temporaryError = nil
        delegate?.textFieldTextDidChange(textField.text, from: self)
    }

    public func validate() {
        guard let textValidationBlock = textValidationBlock else {
            textFieldContainer.layer.borderColor = Constants.defaultBorderColor.cgColor
            errorLabel.styledText = nil
            return
        }
        switch textValidationBlock(textField.text) {
        case .success:
            self.temporaryError = nil
        case .failure(let error):
            self.temporaryError = error
        }
    }

    @objc private func textFieldSecureButtonTapped() {
        textField.isSecureTextEntry.toggle()
        updateTextFieldSecureToggleButton()
    }

    private func updateTextFieldSecureToggleButton() {
        if let appearance = appearance {
            textFieldSecureButtonToggle.setImage(isTextVisible ? appearance.visibleIcon : appearance.invisibleIcon, for: .normal)
            textFieldSecureButtonToggle.setTitle(nil, for: .normal)
        } else {
            textFieldSecureButtonToggle.setImage(nil, for: .normal)
            textFieldSecureButtonToggle.setTitle(isTextVisible ? Constants.visibilityToggleTitleHide : Constants.visibilityToggleTitleShow, for: .normal)
        }
    }

    private func updateErrorState() {
        if let error = error ?? temporaryError {
            textFieldContainer.layer.borderColor = Constants.errorBorderColor.cgColor
            errorLabel.styledText = error.localizedDescription
        } else {
            textFieldContainer.layer.borderColor = textField.isFirstResponder ? Constants.activeBorderColor.cgColor : Constants.defaultBorderColor.cgColor
            errorLabel.styledText = nil
        }
    }

    // MARK: Setup

    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textFieldContainer, errorLabel])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - UITextFieldDelegate

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let hasActiveError = !(error == nil && temporaryError == nil)
        textFieldContainer.layer.borderColor = hasActiveError ? Constants.errorBorderColor.cgColor : Constants.activeBorderColor.cgColor
        if delegate?.canMoveToNextField(from: self) == true {
            textField.returnKeyType = .next
        } else {
            textField.returnKeyType = .done
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard error == nil else { return }
        validate()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterLimit = characterLimit else { return true }
        // Prevent crashing undo bug
        if range.length + range.location > (textField.text?.count ?? 0) {
            return false
        }

        let newLength = (textField.text?.count ?? 0) + string.count - range.length

        if newLength <= characterLimit {
            return true
        } else {
            return false
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.moveToNextField(after: self)
        return false
    }
}

/// Passes touch events to the first subview.
/// Useful for passing touches outside of a subviews frame.
class TextFieldContainer: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let stackView = subviews.first as? UIStackView else { return self }
        let p = stackView.convert(point, from: self)
        return stackView.subviews.first { view -> Bool in
            return view.frame.insetBy(dx: -10, dy: -10).contains(p)
        }
    }
}

public class InputFieldGroup: InputFieldDelegate {

    public var fields: [InputField]
    public var shouldClearErrors: Bool
    public var textFieldDidChangeBlock: ((String?, InputField) -> Void)?
    public var completion: (() -> Void)?

    private var previousEditedTextField: InputField?

    // MARK: - Lifecycle

    /// Initializer
    /// - Parameters:
    ///   - fields: Text fields that work as a group
    ///   - shouldClearErrors: **Default: `false`**, if `true` typing in a text field will clear it's `temporaryError`, and will reset `error` on **all** fields.
    ///   - completion: Block of code called after editing has completed in the last text field.
    public init(fields: [InputField], shouldClearErrors: Bool = false, textFieldTextDidChange: ((String?, InputField) -> Void)? = nil, completion: (() -> Void)? = nil) {
        self.fields = fields
        self.shouldClearErrors = shouldClearErrors
        self.textFieldDidChangeBlock = textFieldTextDidChange
        self.completion = completion

        fields.forEach { $0.delegate = self }
    }

    deinit {
        print("InputFieldGroup deinit")
    }

    // MARK: - Actions

    public func becomeFirstResponder() {
        _ = fields.first?.becomeFirstResponder()
    }

    public func resignFirstResponder() {
        fields.forEach { _ = $0.resignFirstResponder() }
    }

    public func clearErrors(temporaryErrors: Bool = true, errors: Bool = true) {
        fields.forEach { inputField in
            if errors {
                inputField.error = nil
            }
            if temporaryErrors {
                inputField.temporaryError = nil
            }
        }
    }

    // MARK: - InputFieldDelegate

    public func textFieldTextDidChange(_ text: String?, from inputField: InputField) {
        defer {
            textFieldDidChangeBlock?(text, inputField)
        }
        guard
            shouldClearErrors,
            inputField != previousEditedTextField
            else { return }
        previousEditedTextField = inputField
        inputField.temporaryError = nil
        fields.forEach { $0.error = nil }
    }

    public func canMoveToNextField(from: InputField) -> Bool {
        defer { previousEditedTextField = nil }
        guard let index = fields.firstIndex(of: from) else { return false }
        return index < fields.count - 1
    }

    public func moveToNextField(after: InputField) {
        defer { previousEditedTextField = nil }
        guard let index = fields.firstIndex(of: after) else { return }
        if index < fields.count - 1 {
            _ = fields[index+1].becomeFirstResponder()
        } else {
            fields.forEach { $0.validate() }
            if fields.allSatisfy({ $0.error == nil && $0.temporaryError == nil }) {
                completion?()
            }
        }
    }
}

#endif
