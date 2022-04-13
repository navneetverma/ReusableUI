//
//  POIBannerHeaderFooterView.swift
//  
//
//  Created by Sindhu Majeti on 9/15/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public class POIBannerHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties

    public let actionView = ActionBannerView()

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

        actionView.bodyText = nil
        actionView.actionTitle = nil
        actionView.action = nil
    }

    // MARK: - Setup

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
