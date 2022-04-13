//
//  LeadingImageCell.swift
//  
//
//  Created by Robert Sparhawk on 2/5/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

/// Table view cell with an image on the left and detail text on the right or an image on the right
open class ImageCell: TableViewCell {

    // MARK: - Properties

    public var titleText: String? {
        didSet {
            titleLabel.styledText = titleText
        }
    }

    public var subtitleText: String? = nil {
        didSet {
            subtitleLabel.styledText = subtitleText
            subtitleStack.isHidden = subtitleText == nil
        }
    }

    public var subtitleStyle: StringStyle? {
        get {
            subtitleLabel.bonMotStyle
        }
        set {
            subtitleLabel.bonMotStyle = newValue
        }
    }

    public var leadingImage: UIImage? = nil {
        didSet {
            leadingImageView.image = leadingImage
            leadingImageView.isHidden = leadingImage == nil
        }
    }

    public var leadingImageTintColor: UIColor? {
        didSet {
            leadingImageView.tintColor = leadingImageTintColor
        }
    }

    public var trailingImage: UIImage? = nil {
        didSet {
            trailingImageView.image = trailingImage
            trailingImageView.isHidden = trailingImage == nil
        }
    }

    public var trailingImageTintColor: UIColor? {
        didSet {
            trailingImageView.tintColor = trailingImageTintColor
        }
    }

    private let titleLabel = UILabel(style: .title2)

    private let subtitleLabel: UILabel = {
        let label = UILabel(style: .message2)
        label.numberOfLines = 0
        return label
    }()

    private let leadingImageView: UIImageView = {
        let leadingImageView = UIImageView()
        leadingImageView.contentMode = .scaleAspectFit
        leadingImageView.translatesAutoresizingMaskIntoConstraints = false
        leadingImageView.isHidden = true
        return leadingImageView
    }()

    private let trailingImageView: UIImageView = {
        let  trailingImageView = UIImageView()
        trailingImageView.contentMode = .scaleAspectFit
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        trailingImageView.isHidden = true
        return trailingImageView
    }()

    private lazy var subtitleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [.flexibleSpace(), subtitleLabel])
        stack.isHidden = true
        return stack
    }()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        titleText = nil
        subtitleText = nil
        subtitleStyle = .message2
        leadingImage = nil
        leadingImageTintColor = nil
        trailingImage = nil
        trailingImageTintColor = nil
    }

    // MARK: - Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 14)

        let topStackView = UIStackView(arrangedSubviews: [leadingImageView, titleLabel, trailingImageView])
        topStackView.alignment = .center
        topStackView.spacing = 10

        let stackView = UIStackView(arrangedSubviews: [topStackView, subtitleStack])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            leadingImageView.widthAnchor.constraint(equalToConstant: 32),
            leadingImageView.heightAnchor.constraint(equalToConstant: 32),
            trailingImageView.widthAnchor.constraint(equalToConstant: 24),
            trailingImageView.heightAnchor.constraint(equalToConstant: 24),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}

#endif
