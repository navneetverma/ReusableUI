//
//  DashboardCardBase.swift
//  
//
//  Created by Siddarth Gandhi on 1/30/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

open class DashboardCardBase: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayer() {
        backgroundColor = UIColor.SS.Grey.white
        layer.cornerRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.11
        layer.shadowOffset = CGSize(width: 1, height: 2)
        layer.shadowRadius = 2
    }

}

#endif
