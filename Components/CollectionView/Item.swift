//
//  Item.swift
//  
//
//  Created by Vishwanath Deshmukh on 6/9/20.
//

#if canImport(UIKit)
import UIKit
import Foundation

public enum Item {

    public typealias Action = (UICollectionView, IndexPath) -> Void
    
    case view(type: UICollectionViewCell.Type, configuration: ((UICollectionViewCell) -> Void), didSelect: Action? = nil, didDeselect: Action? = nil, didHighlight: Action? = nil, didUnhighlight: Action? = nil)

     var itemType: UICollectionViewCell.Type {
         switch self {
         case .view(let type, _, _, _, _, _):
             return type
         }
     }

    var cellIdentifier: String {
        return itemType.identifier
    }
}

public extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

#endif
