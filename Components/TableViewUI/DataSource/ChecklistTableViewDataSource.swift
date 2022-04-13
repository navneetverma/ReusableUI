//
//  File.swift
//  
//
//  Created by Maxamilian Litteral on 12/13/19.
//

#if canImport(UIKit)
import UIKit
import Foundation

/// Protocol > closure because library is crashing with closures because of generics
public protocol ChecklistTableViewDataSourceDelegate: AnyObject {
    func checklistTableViewDataSourceDidSelectIndexPath(_ indexPath: IndexPath)
}

public class ChecklistTableViewDataSource<T: RawRepresentable & CaseIterable & CustomStringConvertible>: TableViewDataSource where T.RawValue == Int {

    public weak var delegate: ChecklistTableViewDataSourceDelegate?

    public init(for selected: T, of set: T.Type = T.self, delegate: ChecklistTableViewDataSourceDelegate?) {
        self.delegate = delegate
        let section = Section(header: nil,
                              rows: set.allCases.map { row in Row.checkmark(title: row.description, value: { return row == selected }) },
                              footer: nil)
        super.init([section])
    }

    // MARK: - UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.checklistTableViewDataSourceDidSelectIndexPath(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        if !tableView.allowsMultipleSelection {
            tableView.visibleCells.forEach {
                $0.accessoryType = .none
            }
        }

        if let cell = tableView.cellForRow(at: indexPath) {
            if tableView.allowsMultipleSelection {
                cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
    }
}

#endif
