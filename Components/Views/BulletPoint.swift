//
//  BulletPoint.swift
//
//
//  Created by Maxamilian Litteral on 10/22/20.
//

#if canImport(UIKit)

import UIKit

public class BulletPoint: UIView {

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        fatalError("Use init(size:) instead")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layer.cornerRadius = frame.width / 2
    }

    public init(size: CGFloat) {
        super.init(frame: .zero)
        setup()
        layer.cornerRadius = size / 2
    }

    // MARK: - Actions

    private func setup() {
        backgroundColor = UIColor.SS.Grey.light
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
    }
}

#endif
