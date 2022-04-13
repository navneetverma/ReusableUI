//
//  ActionRequiredCell.swift
//  
//
//  Created by Robert Sparhawk on 2/26/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

///Cell with title, subtitle, and optional leading ! symbol before subtitle
open class ActionRequiredCell: TableViewCell {
    // MARK: - Members
    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var subtitleLabel = UILabel(style: StringStyle.message2.colored(UIColor.SS.Red.base))

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var subtitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconView, subtitleLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var iconView = UIImageView(image: UIImage(named: "ErrorIcon", in: .module, compatibleWith: traitCollection))

    // MARK: - Lifecycle
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    // MARK: - Config
    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        contentView.addSubview(labelStackView)

        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            labelStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    public func setTitle(text: String?) {
        titleLabel.styledText = text
        titleLabel.isHidden = (text ?? "").isEmpty
    }

    public func setSubtitle(text: String?, actionRequired: Bool) {
        iconView.isHidden = !actionRequired
        subtitleLabel.styledText = text
        subtitleLabel.isHidden = (subtitleLabel.attributedText == nil || subtitleLabel.attributedText?.length == 0)
    }
}
#endif
