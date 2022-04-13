//
//  TextInputTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/12/19.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Table view cell with text field
public class TextInputTableViewCell: TableViewCell, Inputable, UITextFieldDelegate {

    // MARK: - Properties

    public var inputAction: TextInputAction?
    public var returnAction: TextInputDidReturn?
    public var maxCharacters: Int?
    public var secureWhenEditing: Bool? // False if all text should be visible when editing textfield
    public var secureAfterEditing: Bool? // False if text should be visible after editing textfield

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var placeholderText: String? {
        didSet {
            textField.attributedPlaceholder = placeholderText?.styled(with: StringStyle.body1.colored(UIColor.SS.Grey.light))
        }
    }

    public var inputText: String? {
        didSet {
            textField.styledText = inputText
        }
    }

    public var leadingImage: UIImage? {
        didSet {
            leadingImageView.image = leadingImage
            leadingImageView.isHidden = (leadingImage == nil)
        }
    }

    public var isSecure: Bool {
        get {
            textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }

    public var isEditable: Bool = true {
        didSet {
            textField.bonMotStyle?.color = (isEditable ? UIColor.SS.Slate.base : UIColor.SS.Grey.light)
        }
    }

    public private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.bonMotStyle = StringStyle.body1.colored(UIColor.SS.Slate.base).aligned(.right)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidReturn), for: .editingDidEndOnExit)
        return textField
    }()

    private lazy var leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private lazy var titleLabel = UILabel(style: .title2)

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        inputAction = nil
        returnAction = nil
        title = nil
        placeholderText = nil
        inputText = nil
        leadingImage = nil
        secureAfterEditing = nil
        secureWhenEditing = nil
        maxCharacters = nil
        isSecure = false
        isEditable = true
    }

    // MARK: - Actions

    @objc private func textFieldTextDidChange(_ textField: UITextField) {
        inputAction?(textField.text)
    }

    @objc private func textFieldDidReturn(_ textField: UITextField) {
        returnAction?()
    }

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        let titleStack = UIStackView(arrangedSubviews: [leadingImageView, titleLabel, .flexibleSpace()])
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.spacing = 8
        titleStack.alignment = .center

        contentView.addSubview(titleStack)
        contentView.addSubview(textField)

        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: titleStack.trailingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textField.firstBaselineAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beginInput)))
    }

    // MARK: - UITextFieldDelegate

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isEditable
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isSecureTextEntry && !(self.secureWhenEditing ?? true) {
            textField.isSecureTextEntry = false
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        // Will only need to be executed if secure text was turned off for editing
        guard let secureWhenEditing = secureWhenEditing else { return }
        if secureAfterEditing ?? true  && !secureWhenEditing {
            textField.isSecureTextEntry = true
        }
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        guard let maxCharacters = maxCharacters else { return true }
        return count <= maxCharacters
    }

    // MARK: - Inputable

    @objc public func beginInput() {
        textField.becomeFirstResponder()
    }

    public func endInput() {
        textField.resignFirstResponder()
    }
}

#endif
