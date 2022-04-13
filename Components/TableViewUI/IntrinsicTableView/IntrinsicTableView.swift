//
//  IntrinsicTableView.swift
//  
//
//  Created by Maxamilian Litteral on 10/29/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

/// Useful for expanding a table view within a stack view without setting a height constraint
public class IntrinsicTableView: UITableView {
    public override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    public override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

#endif
