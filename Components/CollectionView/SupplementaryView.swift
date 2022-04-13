//
//  SupplementaryView.swift
//  
//
//  Created by Vishwanath Deshmukh on 6/11/20.
//

#if canImport(UIKit)
import UIKit
import Foundation

public enum SupplementaryView {
    case view(type: UICollectionReusableView.Type, configuration: ((UICollectionReusableView) -> Void))

    var headerFooterType: UICollectionReusableView.Type {
        switch self {
        case .view(let headerType, _):
            return headerType
        }
    }

    var supplementaryViewIdentifier: String {
        return headerFooterType.cellIdentifier
    }
}

#endif
