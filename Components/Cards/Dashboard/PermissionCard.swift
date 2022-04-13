//
//  PermissionCard.swift
//  
//
//  Created by Maxamilian Litteral on 3/8/21.
//

import Foundation

#if canImport(UIKit)
import UIKit
import BonMot

public class PermissionCardViewModel {
    public typealias CompletionHandler = ((PermissionCardViewModel, PermissionCard) -> Void)
    public var icon: UIImage
    public var body: String
    public var enabled: Bool
    /// Convert to UIAction when we drop iOS 12
    public var button: (title: String, action: CompletionHandler)
    public var enabledColor: UIColor
    public var disabledColor: UIColor

    var buttonIsVisible: Bool {
        !enabled
    }

    var tintColor: UIColor {
        enabled ? enabledColor : disabledColor
    }

    var state: String {
        enabled ? "on".localized : "off".localized
    }

    public init(icon: UIImage, body: String, enabled: Bool, button: (title: String, action: CompletionHandler), enabledColor: UIColor = UIColor.SS.Blue.base, disabledColor: UIColor = UIColor.SS.Grey.light) {
        self.icon = icon
        self.body = body
        self.enabled = enabled
        self.button = button
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }
}

public final class PermissionCard: UIView {

    // MARK: - Properties

    public var viewModel: PermissionCardViewModel {
        didSet {
            updateUIForViewModel()
        }
    }

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var stateLabel: UILabel = {
        let label = UILabel(style: StringStyle.body2.aligned(.center))
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(style: StringStyle.body1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var button: AmbientButton = {
        let button = AmbientButton(style: .default)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    @available(*, unavailable, message: "Use init(viewModel:) instead")
    public required init?(coder: NSCoder) { fatalError("Use init(viewModel:) instead") }

    @available(*, unavailable, message: "Use init(viewModel:) instead")
    public override init(frame: CGRect) { fatalError("Use init(viewModel:) instead") }

    public init(viewModel: PermissionCardViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    public override func accessibilityActivate() -> Bool {
        guard !viewModel.enabled else { return true }
        buttonPressed()
        return true
    }

    @objc private func buttonPressed() {
        viewModel.button.action(self.viewModel, self)
    }

    // MARK: Setup

    private func setup() {
        layoutMargins = UIEdgeInsets(xInset: 30, yInset: 22)
        backgroundColor = UIColor.SS.Grey.cool
        layer.cornerRadius = 5
        isAccessibilityElement = true
        shouldGroupAccessibilityChildren = true

        let stackView = UIStackView(arrangedSubviews: [iconView, stateLabel, bodyLabel, button])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

        updateUIForViewModel()
    }

    public func updateUIForViewModel() {
        iconView.image = viewModel.icon
        iconView.tintColor = viewModel.tintColor
        stateLabel.styledText = viewModel.state
        stateLabel.textColor = viewModel.tintColor
        bodyLabel.styledText = viewModel.body
        button.title = viewModel.button.title
        button.disabledTitle = ""
        button.isEnabled = !viewModel.enabled

        // Accessibility
        accessibilityLabel = viewModel.body
        accessibilityValue = viewModel.state
        accessibilityHint = viewModel.enabled ? nil : viewModel.button.title
        accessibilityTraits = .button
    }
}
#endif
