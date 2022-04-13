//
//  EmptyStateCardView.swift
//  
//
//  Created by Robert Sparhawk on 1/28/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class EmptyStateCardView: UIView {
    public enum CardStyle {
        case primary, secondary

        var textColor: UIColor {
            switch self {
            case .primary:
                return UIColor.SS.Grey.white
            case .secondary:
                return UIColor.SS.Blue.base
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return UIColor.SS.Blue.base
            case.secondary:
                return UIColor.SS.Grey.white
            }
        }

        var imageTintColor: UIColor {
            switch self {
            case .primary:
                return UIColor.SS.Grey.white
            case .secondary:
                return UIColor.SS.Blue.base
            }
        }
    }

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    public lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()

    public lazy var leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public lazy var trailingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public convenience init(title: String, subtitle: String?, leadingImage: UIImage?, trailingImage: UIImage?, cardStyle: CardStyle) {
        self.init()
        setup(title: title, subtitle: subtitle, leadingImage: leadingImage, trailingImage: trailingImage, cardStyle: cardStyle)
    }

    func setup(title: String, subtitle: String?, leadingImage: UIImage?, trailingImage: UIImage?, cardStyle: CardStyle) {
        backgroundColor = cardStyle.backgroundColor
        layer.cornerRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.11
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 2

        if let leadImage = leadingImage?.withRenderingMode(.alwaysTemplate) {
            leadingImageView.tintColor = cardStyle.imageTintColor
            leadingImageView.image = leadImage

            addSubview(leadingImageView)
            NSLayoutConstraint.activate([
                leadingImageView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 30),
                leadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                leadingImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        }

        if let trailImage = trailingImage?.withRenderingMode(.alwaysTemplate) {
            trailingImageView.image = trailImage
            trailingImageView.tintColor = cardStyle.imageTintColor

            self.addSubview(self.trailingImageView)
            NSLayoutConstraint.activate([
                trailingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
                trailingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                trailingImageView.widthAnchor.constraint(equalToConstant: 15)
            ])
        }

        titleLabel.textColor = cardStyle.textColor
        titleLabel.text = title
        addSubview(titleLabel)

        if !(subtitle ?? "").isEmpty {
            subtitleLabel.textColor = cardStyle.textColor
            subtitleLabel.text = subtitle
            addSubview(subtitleLabel)

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25),
                titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: subtitleLabel.topAnchor, constant: -5),

                subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
                subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
                subtitleLabel.bottomAnchor.constraint(equalTo:bottomAnchor, constant: -25)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 55),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
            ])
        }

        NSLayoutConstraint.activate([heightAnchor.constraint(greaterThanOrEqualToConstant: 90)])
    }
}

#endif
