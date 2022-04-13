//
//  AlertViewController.swift
//  SimpliSafe Mobile Command
//
//  Created by Siddarth Gandhi on 1/16/20.
//  Copyright © 2020 SimpliSafe. All rights reserved.
//
#if canImport(UIKit)
import BonMot
import UIKit

public enum AlertStyle {
    case info
    case warning
    case alert

    var color: UIColor {
        switch self {
        case .info:
            return UIColor.SS.Blue.base
        case .warning:
            return UIColor.SS.Yellow.base
        case .alert:
            return UIColor.SS.Red.base
        }
    }
}

public enum BodyString {
    case plainString(String)
    case attributed(NSAttributedString)
    case empty
}

public class AlertViewController: UIViewController {

    public enum Style {
        case alert, actionSheet
    }

    // MARK: - Properties

    /// The supertitle of the alert
    public var supertitleText: String? {
        didSet {
            supertitleLabel.styledText = supertitleText
            supertitleLabel.isHidden = supertitleText?.isEmpty ?? true
        }
    }
    public var supertitleStyle: AlertStyle {
        didSet {
            supertitleLabel.bonMotStyle?.color = supertitleStyle.color
        }
    }
    /// The title of the alert.
    public var titleText: String? {
        didSet {
            titleLabel.styledText = titleText
            titleLabel.isHidden = titleText?.isEmpty ?? true
        }
    }
    /// Descriptive text that provides more details about the reason for the alert.
    public var messageStyle: BodyString {
        didSet {
            switch messageStyle {
            case .plainString(let text):
                messageLabel.styledText = text
            case .attributed(let attributedText):
                messageLabel.attributedText = attributedText
            case .empty:
                messageLabel.isHidden = true
            }
        }
    }
    public var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = image == nil
        }
    }

    private let style: Style

    private lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = UIColor.SS.Grey.cool
        alertView.layer.cornerRadius = 3
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()

    private lazy var supertitleLabel: UILabel = {
        let label = UILabel(style: StringStyle.label2.colored(supertitleStyle.color), text: supertitleText)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(style: .headline1, text: titleText)
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        switch messageStyle {
        case .plainString(let text):
            label.bonMotStyle = .body1
            label.styledText = text
        case .attributed(let attributedText):
            label.attributedText = attributedText
        case .empty:
            label.isHidden = true
        }
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = image == nil
        return imageView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var alertStackView: UIStackView = {
        let labelsStackView = UIStackView(arrangedSubviews: [supertitleLabel, titleLabel, messageLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 0
        labelsStackView.distribution = .fillProportionally

        labelsStackView.setCustomSpacing(2, after: supertitleLabel)

        let alertStackView = UIStackView(arrangedSubviews: [labelsStackView, imageView, buttonStackView])
        alertStackView.axis = .vertical
        alertStackView.spacing = 20
        alertStackView.distribution = .fillProportionally
        alertStackView.translatesAutoresizingMaskIntoConstraints = false
        return alertStackView
    }()

    // MARK: - Lifecycle

    /// Creates and returns a view controller for displaying an alert to the user.
    ///
    /// - Parameters:
    ///     - supertitle: The supertitle of the alert.
    ///     - supertitleStyle: Selects the color of text of the supertitle
    ///     - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///     - message: Descriptive text that provides additional details about the reason for the alert.
    ///
    /// - Returns: An initialized alert controller object.
    public required init(supertitle: String? = nil, supertitleStyle: AlertStyle = .info, title: String?, message: BodyString = .empty, image: UIImage? = nil, preferredStyle: Style = .alert) {
        self.titleText = title
        self.messageStyle = message
        self.supertitleText = supertitle
        self.supertitleStyle = supertitleStyle
        self.image = image
        self.style = preferredStyle
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        registerBackgroundedNotification()
    }

    public required init?(coder: NSCoder) { fatalError("Use init(supertitle:supertitleStyle:title:message:) instead") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        modalPresentationStyle = .fullScreen
        setupView()
    }

    // MARK: - Actions

    /// Attaches an action object to the alert.
    ///
    /// - Parameters:
    ///     - action: The action object to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
    public func addAction(_ action: AlertAction) {
        addActions([action])
    }

    /// Attaches multiple action objects to the alert.
    ///
    /// - Parameters:
    ///     - actions: The action objects to display as part of the alert. Actions are displayed as buttons in the alert. The action object provides the button text and the action to be performed when that button is tapped.
    public func addActions(_ actions: [AlertAction]) {
        actions.forEach({
            let button = $0.button
            button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        })
    }

    @objc private func handleButtonTapped(_ sender: AnyObject) {
        guard
            let sender = sender as? AlertActionButton,
            sender.alertAction?.isEnabled == true
        else { return }
        dismiss(animated: true) {
            sender.alertAction?.handler?()
        }
    }
}

// MARK: - UI Setup

extension AlertViewController {
    private func setupView() {
        view.addSubview(alertView)
        alertView.addSubview(alertStackView)

        supertitleLabel.isHidden = supertitleText?.isEmpty ?? true
        titleLabel.isHidden = titleText?.isEmpty ?? true
        configureLayout()
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            alertStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 25),
            alertStackView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            alertStackView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 25),
            alertStackView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
        ])

        switch style {
        case .alert:
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        case .actionSheet:
            alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        }
    }
}

// TODO: - Remove extension after thinking screen/backgrounding bug is fixed
extension AlertViewController {
    private func registerBackgroundedNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackgrounding), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc private func handleBackgrounding() {
        dismiss(animated: true, completion: nil)
    }
}
#endif
