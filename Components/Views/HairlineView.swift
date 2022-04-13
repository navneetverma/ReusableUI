//
//  HairlineView.swift
//  
//
//  Created by Maxamilian Litteral on 11/25/20.
//

#if canImport(UIKit)
import UIKit

public class HairlineView: UIView {
    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 1 / UIScreen.main.scale)
    }
}

#endif
