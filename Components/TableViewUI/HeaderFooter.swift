//
//  HeaderFooter.swift
//  
//
//  Created by Maxamilian Litteral on 12/16/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

public enum HeaderFooterConfiguration {
    /// Uses the default header / footer style for table views.
    case text(String)
    case textWithImage(String, image: UIImage)
    case view(type: UITableViewHeaderFooterView.Type, configuration: ((UITableViewHeaderFooterView) -> Void))
    case poiBanner(String, AlertStyle, String, Action? = nil)

    var headerFooterType: UITableViewHeaderFooterView.Type {
        switch self {
        case .text(_):
            return UITableViewHeaderFooterView.self
        case .textWithImage(_, _):
            return LabelAndImageHeaderFooterView.self
        case .view(let headerFooterType, _):
            return headerFooterType
        case .poiBanner(_, _, _, _):
            return POIBannerHeaderFooterView.self
        }
    }

    var headerFooterIdentifier: String {
        return headerFooterType.identifier
    }
}

#endif
