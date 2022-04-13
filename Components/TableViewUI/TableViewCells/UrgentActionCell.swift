//
//  UrgentActionCell.swift
//  
//
//  Created by Robert Sparhawk on 4/16/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

///Cell displaying urgent action with button to take action
open class UrgentActionCell: TableViewCell {

    // MARK: - Properties

    public let actionView = ActionBannerView(type: .alert)

    // MARK: - Lifecycle

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()

        actionView.bodyText = nil
        actionView.actionTitle = nil
        actionView.action = nil
    }

    private func setup() {
        actionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionView)

        NSLayoutConstraint.activate([
            actionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            actionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

}

#endif
