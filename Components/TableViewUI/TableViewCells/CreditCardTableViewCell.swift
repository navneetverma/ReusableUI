//
//  CreditCardTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 1/28/20.
//

#if canImport(UIKit)
import UIKit

/// Used for plan and billing screen. Move back into app once Apple solves importing to Objective-C
public class CreditCardTableViewCell: RightDetailTableViewCell {

    // MARK: - Properties

    public let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 38)
        ])
        return imageView
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        cardImageView.image = nil
    }

    // MARK: - Actions

    private func setup() {
        contentView.addSubview(cardImageView)

        NSLayoutConstraint.activate([
            cardImageView.trailingAnchor.constraint(equalTo: detailLayoutGuide.leadingAnchor, constant: -6),
            cardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

#endif
