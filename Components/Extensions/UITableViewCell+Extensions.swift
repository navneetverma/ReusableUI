//
//  UITableViewCell+Extensions.swift
//  
//
//  Created by Maxamilian Litteral on 12/16/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

public extension UITableViewCell {
    private enum Separators {
        static let middle = UIEdgeInsets(xInset: 24, yInset: 0)
        static let last = UIEdgeInsets.zero
    }

    static var identifier: String {
        return String(describing: self)
    }

    var tableView: UITableView? {
        var responder = next
        while responder != nil {
            if responder is UITableView {
                break
            }
            responder = responder?.next
        }
        return responder as? UITableView
    }

    /// Used to force the table view to refresh the cell size when using automatic row height.
    /// See: https://stackoverflow.com/a/51280798
    func resizeIfNeeded() {
        guard let tableView = tableView else { return }
        tableView.performBatchUpdates(nil, completion: nil)
    }

    func setSeparatorInset(for indexPath: IndexPath, in tableView: UITableView) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            separatorInset = Separators.last
        } else {
            separatorInset = Separators.middle
        }
    }
}

public extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}

public extension UITableView {
    var isGrouped: Bool {
        switch style {
        case .plain:
            return false
        default:
            return true
        }
    }
}

#endif
