//
//  TableViewController.swift
//  
//
//  Created by Maxamilian Litteral on 1/8/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

open class TableViewController: UITableViewController {

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .TableViewBackgroundColor
    }
}

#endif
