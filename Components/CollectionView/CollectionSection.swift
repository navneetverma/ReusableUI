//
//  CollectionSection.swift
//  
//
//  Created by Vishwanath Deshmukh on 6/9/20.
//

#if canImport(UIKit)
import UIKit
import Foundation

public class CollectionSection {
    public let header: SupplementaryView?
    public let items: [Item]
    public let footer: SupplementaryView?

    public init(header: SupplementaryView?, items: [Item], footer: SupplementaryView?) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}

public extension UICollectionReusableView {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

#endif
