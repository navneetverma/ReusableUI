//
//  BulletView.swift
//  
//
//  Created by Maxamilian Litteral on 10/6/20.
//
#if canImport(UIKit)

import UIKit

public protocol BulletItem {
    var title: String { get set }
    var bulletIcon: UIImage? { get set }
}

public final class BulletView: UIStackView {
    // MARK: - Properties

    public let title: String
    public let bullets: [BulletItem]
    public let buttonTitle: String?
    public let buttonAction: (() -> Void)?

    // MARK: - Lifecycle

    public required init(coder: NSCoder) { fatalError("Use init(title:bullets:buttonTitle:buttonAction:) instead") }

    public override init(frame: CGRect) { fatalError("Use init(title:bullets:bulletIcon:buttonTitle:buttonAction:) instead") }

    public init(title: String, bullets: [BulletItem], buttonTitle: String?, buttonAction: (() -> Void)?) {
        self.title = title
        self.bullets = bullets
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    @objc private func buttonPressed() {
        buttonAction?()
    }

    // MARK: Setup

    private func setup() {
        alignment = .leading
        axis = .vertical
        distribution = .fill
        spacing = 8

        let titleLabel = UILabel(style: .title2, text: title)
        titleLabel.numberOfLines = 0
        addArrangedSubview(titleLabel)

        bullets.forEach {
            let label = UILabel(style: .body4, text: $0.title, image: $0.bulletIcon, imageTintColor: UIColor.SS.Blue.base)
            label.numberOfLines = 0
            addArrangedSubview(label)
        }

        var viewToSpaceAfter: UIView?
        if let buttonTitle = buttonTitle {
            viewToSpaceAfter = arrangedSubviews.last
            let button = AmbientButton(title: buttonTitle)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            addArrangedSubview(button)
        }

        if let viewToSpaceAfter = viewToSpaceAfter {
            setCustomSpacing(16, after: viewToSpaceAfter)
        }
    }
}



#endif
