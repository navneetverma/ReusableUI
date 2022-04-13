//
//  TableViewCell.swift
//  
//
//  Created by Sindhu Majeti on 9/17/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

open class TableViewCell: UITableViewCell {

    // MARK: - Properties

    private var disabledOverlay = UIView(frame: .zero)

    // MARK: - Lifecycle

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupOverlay()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupOverlay()
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        disabledOverlay.isHidden = true
        isUserInteractionEnabled = true
    }

    // MARK: - Functions

    private func setupOverlay() {
        disabledOverlay.backgroundColor = UIColor.SS.Grey.cool
        disabledOverlay.alpha = 0.7
        disabledOverlay.translatesAutoresizingMaskIntoConstraints = false
        disabledOverlay.isHidden = true
        addSubview(disabledOverlay)
        NSLayoutConstraint.activate([
            disabledOverlay.topAnchor.constraint(equalTo: topAnchor),
            disabledOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            disabledOverlay.rightAnchor.constraint(equalTo: rightAnchor),
            disabledOverlay.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }

    public func setEnabled(enabled: Bool) {
        isUserInteractionEnabled = enabled
        if !enabled {
            bringSubviewToFront(disabledOverlay)
        }
        disabledOverlay.isHidden = enabled
    }
}
#endif
