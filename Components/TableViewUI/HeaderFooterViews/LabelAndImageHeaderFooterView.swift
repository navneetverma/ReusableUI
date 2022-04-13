//
//  LabelAndImageHeaderFooterView.swift
//  
//
//  Created by Maxamilian Litteral on 1/7/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class LabelAndImageHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel = UILabel(style: .title2)

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        image = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 0)

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        let heightConstraint = stackView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            heightConstraint,

            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}

#endif
