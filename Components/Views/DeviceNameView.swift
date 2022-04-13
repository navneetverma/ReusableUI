//
//  DeviceNameView.swift
//  
//
//  Created by Navneet Verma on 9/15/20.
//
#if canImport(UIKit)
import Foundation
import BonMot
import UIKit

public protocol DeviceNameViewDelegate: AnyObject {
    func deviceNameUpdated(to name: String)
}

public class DeviceNameView: UIStackView, UITextFieldDelegate {

    // MARK: - Properties

    private enum Constants {
        static let maxNameLength = 14
    }

    private let deviceName: String
    private let deviceImage: UIImage
    private let batteryLevel: BatteryLevel?

    public weak var delegate: DeviceNameViewDelegate?

    private lazy var deviceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = deviceImage
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.bonMotStyle = StringStyle.headline2.byAdding(.alignment(.center))
        textField.styledText = deviceName
        textField.placeholder = "DeviceNameView.TextField.Placeholder".localized
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.rightView = editButton
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "EditText", in: .module, compatibleWith: nil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(editText), for: .touchUpInside)
        return button
    }()

    private lazy var batteryImageView: UIImageView = {
        let batteryImageView = UIImageView(image: batteryLevel?.image)
        batteryImageView.contentMode = .scaleAspectFit
        batteryImageView.translatesAutoresizingMaskIntoConstraints = false
        return batteryImageView
    }()

    // MARK: - Lifecycle

    @available(*, unavailable)
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public init(deviceName: String, deviceImage: UIImage, batteryLevel: BatteryLevel? = nil) {
        self.deviceName = deviceName
        self.deviceImage = deviceImage
        self.batteryLevel = batteryLevel
        super.init(frame: .zero)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        addArrangedSubview(deviceImageView)
        addArrangedSubview(nameTextField)

        if batteryLevel != nil {
            addArrangedSubview(batteryImageView)
        }

        spacing = 10
        axis = .vertical
        alignment = .center

        NSLayoutConstraint.activate([
            deviceImageView.heightAnchor.constraint(equalToConstant: 40),
            deviceImageView.widthAnchor.constraint(equalToConstant: 40),
            batteryImageView.heightAnchor.constraint(equalToConstant: 25),
            batteryImageView.widthAnchor.constraint(equalToConstant: 25)
        ])
    }

    // MARK: - Action

    @objc private func editText() {
        nameTextField.becomeFirstResponder()
    }

    // MARK: - Keyboard Hiding

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        self.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    // MARK: - UITextFieldDelegate

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = nameTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= Constants.maxNameLength
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let updatedName = textField.text,
              deviceName != updatedName
        else { return }
        delegate?.deviceNameUpdated(to: updatedName)
    }

}

#endif
