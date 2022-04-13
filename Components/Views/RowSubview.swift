//
//  RowSubview.swift
//  
//
//  Created by Siddarth Gandhi on 2/9/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public enum RowSubview {
    case customRowStack(image: UIImage? = nil, subtitle: String? = nil, warning: String? = nil)
    case custom(view: UIView)

    public func makeView() -> UIView {
        switch self {
        case .customRowStack(let image, let subtitle, let warning):
            return buildCustomRowStack(image: image, subtitle: subtitle, warning: warning)
        case .custom(let view):
            return view
        }
    }

    private func buildCustomRowStack(image: UIImage? = nil, subtitle: String? = nil, warning: String? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10

        if image != nil {
            let spacer = UIStackView()
            stackView.addArrangedSubview(spacer)
            stackView.setCustomSpacing(6, after: spacer)

            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }

        if let subtitle = subtitle, !subtitle.isEmpty {
            let subtitleLabel = UILabel(style: .body4, text: subtitle)
            subtitleLabel.numberOfLines = 0
            stackView.addArrangedSubview(subtitleLabel)
        }

        if let warning = warning, !warning.isEmpty {
            let warningLabel = UILabel(
                style: .message1,
                text: warning,
                image: UIImage(named: "WarningIcon", in: .module, compatibleWith: nil)
            )
            warningLabel.numberOfLines = 0
            stackView.addArrangedSubview(warningLabel)
        }

        return stackView
    }
}

#endif
