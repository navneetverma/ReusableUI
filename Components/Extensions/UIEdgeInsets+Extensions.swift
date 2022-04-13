//
//  UIEdgeInsets+Extensions.swift
//  
//
//  Created by Rob Visentin on 2/5/21.
//

import UIKit

public extension UIEdgeInsets {

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(xInset: CGFloat, yInset: CGFloat) {
        self.init(top: yInset, left: xInset, bottom: yInset, right: xInset)
    }

}
