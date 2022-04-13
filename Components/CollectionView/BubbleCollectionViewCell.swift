//
//  File.swift
//  
//
//  Created by Sindhu Majeti on 1/12/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Collection view cell that contains a icon with a ring around it, with a title label.
public class BubbleCollectionViewCell: UICollectionViewCell {

    private enum Constants {
        static let maxWidth: CGFloat = 94
        static let spacing: CGFloat = 4
    }

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

    public var badgeText: String? {
        didSet {
            imageView.badgeText = badgeText
        }
    }

    public var isDottedLine: Bool {
        get {
            imageView.isDottedLine
        }
        set {
            imageView.isDottedLine = newValue
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel(style: StringStyle.title2.byAdding(
            .color(UIColor.SS.Blue.grey),
            .alignment(.center)
        ))
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: RingImageView = {
        let imageView = RingImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        title = nil
        image = nil
        badgeText = nil
        isDottedLine = false
    }

    override public func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.size.width = min(layoutAttributes.size.width, Constants.maxWidth)
        layoutAttributes.size.height = contentView.systemLayoutSizeFitting(
            layoutAttributes.size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        return layoutAttributes
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.spacing),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
}

#endif
