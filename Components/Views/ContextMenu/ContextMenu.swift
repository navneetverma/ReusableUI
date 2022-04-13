//
//  ContextMenu.swift
//  
//
//  Created by Siddarth Gandhi on 6/2/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public final class KiddePicker: UIView, MenuItemsViewControllerDelegate {

    // MARK: - Properties

    public weak var delegate: PickerMenuDelegate?

    private enum Constants {
        static let activeBorderColor = UIColor.SS.Slate.base
        static let inactiveColor = UIColor.SS.Grey.light
        static let errorBorderColor = UIColor.SS.Red.base
    }

    private var presentingViewController: UIViewController
    private var menuTitle: String

    public var options: [PickerMenuOption]
    public var selectedOption: PickerMenuOption? {
        didSet {
            if let selectedOption = selectedOption {
                label.attributedText = selectedOption.rawValue.styled(with: .body2)
            } else {
                label.attributedText = menuTitle.styled(with: .body2)
            }
        }
    }

    public var hasErrors: Bool = false {
        didSet {
            contextMenuContainerView.layer.borderColor = hasErrors ? Constants.errorBorderColor.cgColor : Constants.activeBorderColor.cgColor
        }
    }

    private var deselectedImage: UIImage
    private var selectedImage: UIImage

    private lazy var titleLabel: UILabel = {
        let label = UILabel(
            style: StringStyle.label1.colored(UIColor.SS.Grey.medium),
            text: menuTitle
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        return label
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: deselectedImage)
        arrowImageView.contentMode = .center
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        return arrowImageView
    }()

    private lazy var contextMenuStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, arrowImageView])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contextMenuContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderColor = Constants.inactiveColor.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contextMenuStackView)
        return view
    }()

    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contextMenuTapped))
        return gestureRecognizer
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) { fatalError("init(presentingViewController:menuTitle:options:selectedOption:) has not been implemented") }

    public required init(
        presentingViewController: UIViewController,
        menuTitle: String,
        options: [PickerMenuOption] = [],
        selectedOption: PickerMenuOption? = nil,
        deselectedImage: UIImage,
        selectedImage: UIImage
    ) {
        self.presentingViewController = presentingViewController
        self.menuTitle = menuTitle
        self.options = options
        self.selectedOption = selectedOption
        self.deselectedImage = deselectedImage
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        contextMenuContainerView.backgroundColor = UIColor.SS.Grey.white

        let stackView = UIStackView(arrangedSubviews: [titleLabel, contextMenuContainerView])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addGestureRecognizer(gestureRecognizer)

        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 35),
            contextMenuStackView.leadingAnchor.constraint(equalTo: contextMenuContainerView.leadingAnchor, constant: 15),
            contextMenuStackView.trailingAnchor.constraint(equalTo: contextMenuContainerView.trailingAnchor, constant: -5),
            contextMenuStackView.topAnchor.constraint(equalTo: contextMenuContainerView.topAnchor, constant: 15),
            contextMenuStackView.centerYAnchor.constraint(equalTo: contextMenuContainerView.centerYAnchor),
            contextMenuStackView.heightAnchor.constraint(equalToConstant: 35),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func contextMenuTapped() {
        presentingViewController.resignFirstResponder()
        presentingViewController.view.endEditing(true)
        let menuItems = MenuItemsPicker(options: options, selectedOption: selectedOption)
        menuItems.pickerDelegate = self
        addSubview(menuItems)
        menuItems.showPicker()
    }

    // MARK: - MenuItemsViewControllerDelegate

    func menuOptionsPresented() {
        contextMenuContainerView.layer.borderColor = Constants.activeBorderColor.cgColor
        arrowImageView.image = selectedImage
    }

    func menuOptionsHidden() {
        contextMenuContainerView.layer.borderColor = Constants.inactiveColor.cgColor
        arrowImageView.image = deselectedImage
    }

    func select(option: PickerMenuOption) {
        guard selectedOption?.rawValue != option.rawValue else { return }
        selectedOption = option
        delegate?.PickerMenu(didSelect: option)
        label.attributedText = option.rawValue.styled(with: .body2)
    }
}

#endif
