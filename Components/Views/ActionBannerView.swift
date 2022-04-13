//
//  ActionBannerView.swift
//  
//
//  Created by Rob Visentin on 2/10/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

open class ActionBannerView: UIView {

    public enum `Type` {
        case info, warning, alert

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

    // MARK: - Properties

    public var type: Type = .info {
        didSet {
            backgroundColor = type.color
        }
    }

    public var bodyText: String? {
        didSet {
            bodyLabel.styledText = bodyText
        }
    }

    public var actionTitle: String? {
        didSet {
            actionButton.styledText = actionTitle
        }
    }

    public var action: Action?

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(style: StringStyle.body3.colored(.white))
        label.styledText = bodyText
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.bonMotStyle = StringStyle.link2.colored(.white)
        button.styledText = actionTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(tappedActionButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public init(
        type: Type = .info,
        body: String? = nil,
        actionTitle: String? = nil,
        action: Action? = nil
    ) {
        self.type = type
        self.bodyText = body
        self.actionTitle = actionTitle
        self.action = action
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    @objc private func tappedActionButton() {
        action?()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = type.color

        let stackView = UIStackView(arrangedSubviews: [bodyLabel, actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = 8

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

}

#endif
