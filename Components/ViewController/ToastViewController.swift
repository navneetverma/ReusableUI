//
//  ToastViewController.swift
//  
//
//  Created by Maxamilian Litteral on 6/15/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class Toast: UIView {

    // MARK: - Properties

    private enum Constants {
        static let cornerRadius: CGFloat = 5
    }

    private let text: String
    private let image: UIImage?
    private let duration: TimeInterval

    let containerView = UIView()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) { fatalError("Use init(title:icon:duration:) instead") }

    public override init(frame: CGRect) { fatalError("Use init(title:icon:duration:) instead") }

    public init(title: String, icon: UIImage?, duration: TimeInterval = 2.0) {
        self.text = title
        self.image = icon
        self.duration = duration
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    private func setup() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.cornerRadius = Constants.cornerRadius

        let imageView = UIImageView(image: image)
        imageView.isHidden = image == nil
        let titleLabel = UILabel(style: .body2, text: text)
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),

            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
}

#endif
