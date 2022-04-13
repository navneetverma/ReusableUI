//
//  AlertAction.swift
//  SimpliSafe Mobile Command
//
//  Created by Siddarth Gandhi on 1/16/20.
//  Copyright © 2020 SimpliSafe. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit

public class AlertAction {

    /// Styles to apply to action buttons in an alert.
    public enum Style {
        case `default`, cancel, destructive
    }

    // MARK: - Properties

    /// The title of the action’s button.
    public var title: String
    /// The style that is applied to the action’s button.
    public var style: Style
    internal var handler: (() -> Void)?

    /// A Boolean value indicating whether the action is currently enabled.
    public var isEnabled: Bool = true

    private lazy var actionButton: AlertActionButton = {
        let actionButton = AlertActionButton(style: style == .default ? .default : .alert, title: title)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.alertAction = self
        return actionButton
    }()

    private lazy var cancelButton: AlertActionButton = {
        let cancelButton = AlertActionButton(priority: .tertiary, title: title)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        cancelButton.alertAction = self
        return cancelButton
    }()

    internal var button: AlertActionButton {
        switch style {
        case .default, .destructive:
            return actionButton
        case .cancel:
            return cancelButton
        }
    }

    // MARK: - Lifecycle

    /// Create and return an action with the specified title and behavior.
    ///
    /// - Parameters:
    ///     - title: The text to use for the button title. The value you specify should be localized for the user’s current language.
    ///     - style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in AlertAction.Style.
    ///     - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    ///
    /// - Returns: A new alert action object.
    public required init(title: String, style: Style, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }

}

internal class AlertActionButton: CTAButton {
    var alertAction: AlertAction?
}
#endif
