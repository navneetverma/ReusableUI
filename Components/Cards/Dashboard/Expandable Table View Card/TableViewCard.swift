//
//  TableViewCard.swift
//  
//
//  Created by Maxamilian Litteral on 10/23/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

public protocol TableViewCardDataSource {
    /// "Show More" / "Show Less"
    var shouldShowToggleButton: Bool { get }
    var numberOfVisibleObjects: Int { get }
    var toggleSensorsButtonText: String { get }
    var rowHeight: CGFloat { get }

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath)
    func didSelectRowAt(_ indexPath: IndexPath)
    func toggleShowingAllVisibleObjects()
}

open class TableViewCard<CellType: UITableViewCell>: DashboardCardBase, UITableViewDataSource, UITableViewDelegate {

    private lazy var tableView: UITableView = {
        let tableView = IntrinsicTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CellType.self, forCellReuseIdentifier: CellType.identifier)
        tableView.register(TableViewCardToggleCell.self, forCellReuseIdentifier: TableViewCardToggleCell.identifier)
        tableView.scrollsToTop = false
        tableView.isScrollEnabled = false
        tableView.separatorInset = .zero
        tableView.setContentHuggingPriority(.required, for: .vertical)
        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        tableView.layer.cornerRadius = 3
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let dataSource: TableViewCardDataSource

    public required init?(coder: NSCoder) { fatalError("Use init(viewModel:) instead") }

    public override init(frame: CGRect) { fatalError("Use init(viewModel:) instead") }

    public init(dataSource: TableViewCardDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    public func reloadTable() {
        tableView.reloadData()
    }

    // MARK: Setup

    private func setup() {
        backgroundColor = .white

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.shouldShowToggleButton ? 2 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dataSource.numberOfVisibleObjects
        case 1:
            return 1
        default:
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else { fatalError("Did not register cell with identifier \"Cell\"") }
            dataSource.configureCell(cell, at: indexPath)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCardToggleCell.identifier, for: indexPath) as? TableViewCardToggleCell else { fatalError("Did not register cell with identifier \"Cell\"") }
            cell.configure(title: dataSource.toggleSensorsButtonText)
            return cell
        default:
            fatalError("Invalid table section")
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return dataSource.rowHeight
        case 1:
            return 36 // "Show more" / "Show less" button
        default:
            return 0
        }
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            dataSource.didSelectRowAt(indexPath)
        case 1:
            dataSource.toggleShowingAllVisibleObjects()
            tableView.reloadData()
        default:
            break
        }
    }

}

#endif
