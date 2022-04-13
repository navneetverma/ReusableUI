//
//  TableViewDataSource.swift
//  
//
//  Created by Maxamilian Litteral on 12/13/19.
//

#if canImport(UIKit)
import UIKit
import Foundation

public class TableViewDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    public var sections: [Section]

    public var sectionCount: Int {
        return sections.count
    }

    public var willDisplayCell: ((UITableViewCell, IndexPath) -> Void)?

    // MARK: - Lifecycle

    public init(_ sections: [Section]) {
        self.sections = sections
        super.init()
    }

    // MARK: - Actions

    public func registerCells(with tableView: UITableView) {
        let cellTypes = sections.flatMap { $0.rows }.map { $0.cellType }
        cellTypes.forEach {
            tableView.register($0, forCellReuseIdentifier: $0.identifier)
        }
    }

    public func registerHeaderFooters(with tableView: UITableView) {
        var headerFooterTypes = sections.compactMap { $0.header?.headerFooterType }
        headerFooterTypes.append(contentsOf: sections.compactMap { $0.footer?.headerFooterType })
        headerFooterTypes.forEach {
            tableView.register($0, forHeaderFooterViewReuseIdentifier: $0.identifier)
        }
        tableView.estimatedSectionHeaderHeight = 28
        tableView.estimatedSectionFooterHeight = 28
    }

    public subscript(_ indexPath: IndexPath) -> Row? {
        return row(at: indexPath)
    }

    public func numberOfRows(in section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        let section = sections[section]
        return section.rows.count
    }

    public func row(at indexPath: IndexPath) -> Row? {
        guard sections.indices.contains(indexPath.section) else { return nil }
        let section = sections[indexPath.section]
        guard section.rows.indices.contains(indexPath.row) else { return nil }
        return section.rows[indexPath.row]
    }

    private func configure(_ cell: UITableViewCell, for row: Row, indexPath: IndexPath, in tableView: UITableView) {
        cell.setSeparatorInset(for: indexPath, in: tableView)

        switch row {
        case let .cell(title, accessory, configure, _):
            if let cell = cell as? TitleTableViewCell {
                cell.title = title
            } else {
                cell.textLabel?.text = title
            }
            cell.accessoryType = accessory
            configure?(cell)
        case let .imageCell(title, subtitle, accessory, configure, leadingImage, trailingImage, imageColor, _):
            if let cell = cell as? ImageCell {
                cell.titleText = title
                cell.subtitleText = subtitle

                if let cellImage = leadingImage {
                    if let imageTintColor = imageColor {
                        cell.leadingImage = cellImage.withRenderingMode(.alwaysTemplate)
                        cell.leadingImageTintColor = imageTintColor
                    } else {
                        cell.leadingImage = cellImage
                    }
                }
                if let cellImage = trailingImage {
                    if let imageTintColor = imageColor {
                        cell.trailingImage = cellImage.withRenderingMode(.alwaysTemplate)
                        cell.trailingImageTintColor = imageTintColor
                    } else {
                        cell.trailingImage = cellImage
                    }
                }
            } else {
                cell.textLabel?.text = title
            }
            cell.accessoryType = accessory
            configure?(cell)
        case let .detail(title, subtitle, detail, configure, accessory, _):
            if let cell = cell as? RightDetailTableViewCell {
                cell.title = title
                cell.subtitle = subtitle
                cell.detailText = detail
            } else {
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
            }
            cell.accessoryType = accessory
            configure?(cell)
        case let .subtitle(title, detail, configure, accessory, _):
            if let cell = cell as? SubtitleTableViewCell {
                cell.title = title
                cell.subtitle = detail
            } else {
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = detail
            }
            cell.accessoryType = accessory
            configure?(cell)
        case let .checkmark(title, value, action):
            if let cell = cell as? CheckmarkTableViewCell {
                cell.title = title
                cell.isCheckmarked = value()
                cell.toggleAction = action
            }
        case let .toggle(title: title, state: state, rowSubview: rowSubview, value: value, didToggle: action):
            if let cell = cell as? ToggleTableViewCell {
                cell.title = title
                cell.state = state
                cell.rowSubview = rowSubview
                cell.toggle.isOn = value()
                cell.toggleAction = action
            }
        case let .inputField(title, value, action, returnAction, configure):
            if let cell = cell as? TextInputTableViewCell {
                cell.title = title
                cell.inputText = value()
                cell.inputAction = action
                cell.returnAction = returnAction
                configure?(cell)
                cell.selectionStyle = .none
            }
        case let .textWithButton(title, buttonTitle, _):
            if let cell = cell as? TextWithButtonTableViewCell {
                cell.bodyText = title
                cell.buttonText = buttonTitle
            }
        case let .view(_, configuration, _):
            configuration(cell)
        case let .radioButton(title, detail, value, action):
            if let cell = cell as? RadioButtonTableViewCell {
                cell.title = title
                cell.detailText = detail
                cell.isToggleSelected = value()
                cell.toggleAction = { [weak self, weak tableView] in
                    if let self = self, let tableView = tableView {
                        self.deselectRadioOptions(tableView: tableView, indexPath: indexPath)
                    }
                    action?($0)
                }
            }
        case let .radioPillButton(title, value, action):
            if let cell = cell as? RadioPillButtonTableViewCell {
                cell.title = title
                cell.isToggleSelected = value()
                cell.toggleAction = { [weak self, weak tableView] in
                    if let self = self, let tableView = tableView {
                        self.deselectRadioOptions(tableView: tableView, indexPath: indexPath)
                    }
                    action?($0)
                }
            }
        case let .checkboxButton(title, detail, value, action):
            if let cell = cell as? CheckboxButtonTableViewCell {
                cell.title = title
                cell.detailText = detail
                cell.isToggleSelected = value()
                cell.toggleAction = action
            }
        case let .slider(title, detail, options, value, didSelect, configuration):
            if let cell = cell as? SliderTableViewCell {
                cell.title = title
                cell.detailText = detail
                cell.configure(value: value, options: options, callback: didSelect)
                configuration?(cell)
                cell.selectionStyle = .none
            }
        case let .timer(title, detail, range, step, currentValue, durationDidChange):
            if let cell = cell as? TimerTableViewCell {
                cell.title = title
                cell.detailText = detail
                cell.selectionStyle = .none
                cell.valueRange = range
                cell.stepValue = step
                cell.currentValue = currentValue()
                cell.valueDidChange = durationDidChange
            }
        case let .actionRequired(title, subtitle, actionRequired, accessory, _):
            if let cell = cell as? ActionRequiredCell {
                cell.setTitle(text: title)
                cell.setSubtitle(text: subtitle, actionRequired: actionRequired)
                cell.accessoryType = accessory
            }
        case let .urgentAction(text, actionTitle, buttonAction):
            if let cell = cell as? UrgentActionCell {
                cell.actionView.bodyText = text
                cell.actionView.actionTitle = actionTitle
                cell.actionView.action = buttonAction
            }
        case let .batteryLevel(title, subtitle, batteryLevel, accessory, configure, leadingImage, _):
            if let cell = cell as? BatteryLevelIndicatorTableViewCell {
                cell.titleText = title
                cell.subtitleText = subtitle
                cell.batteryLevel = batteryLevel
                cell.leadingImage = leadingImage
                cell.accessoryType = accessory
                configure?(cell)
            }
        }
    }

    private func deselectRadioOptions(tableView: UITableView, indexPath: IndexPath) {
        // Turn everything to false
        tableView.indexPathsForVisibleRows?.forEach { visibleIndexPath in
            guard
                visibleIndexPath.section == indexPath.section,
                let cell = tableView.cellForRow(at: visibleIndexPath) as? RadioOptionContainer
                else { return }
            cell.isToggleSelected = (visibleIndexPath.row == indexPath.row)
        }
    }

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(in: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = row(at: indexPath) else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)
        configure(cell, for: row, indexPath: indexPath, in: tableView)
        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        guard
            let headerType = section.header,
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerType.headerFooterIdentifier)
            else { return nil }
        switch headerType {
        case .text(let text):
            headerView.textLabel?.text = text
            headerView.textLabel?.textColor = UIColor.TableViewHeaderColor
        case .textWithImage(let text, let image):
            if let headerView = headerView as? LabelAndImageHeaderFooterView {
                headerView.title = text
                headerView.image = image
            }
        case .view(_, let configuration):
            configuration(headerView)
        case .poiBanner(let bannerText, let alertStyle, let buttonTitle, let buttonAction):
            if let headerView = headerView as? POIBannerHeaderFooterView {
                headerView.actionView.bodyText = bannerText
                headerView.actionView.backgroundColor = alertStyle.color
                headerView.actionView.actionTitle = buttonTitle.uppercased()
                headerView.actionView.action = buttonAction
            }
        }
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[section].header != nil else {
            if tableView.isGrouped {
                return 28
            } else {
                return 0
            }
        }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let section = sections[section]
        guard
            let footerType = section.footer,
            let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerType.headerFooterIdentifier)
            else { return nil }
        switch footerType {
        case .text(let text):
            footerView.textLabel?.text = text
            footerView.textLabel?.textColor = UIColor.TableViewHeaderColor
            footerView.textLabel?.numberOfLines = 0
        case .textWithImage(let text, let image):
            if let footerView = footerView as? LabelAndImageHeaderFooterView {
                footerView.title = text
                footerView.image = image
            }
        case .view(_, let configuration):
            configuration(footerView)
        case .poiBanner(let bannerText, let alertStyle, let buttonTitle, let buttonAction):
            if let footerView = footerView as? POIBannerHeaderFooterView {
                footerView.actionView.bodyText = bannerText
                footerView.actionView.backgroundColor = alertStyle.color
                footerView.actionView.actionTitle = buttonTitle.uppercased()
                footerView.actionView.action = buttonAction
            }
        }
        return footerView
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard sections[section].footer != nil else { return 0 }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.TableViewHeaderColor
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = row(at: indexPath) else { return }

        tableView.deselectRow(at: indexPath, animated: true)

        switch row {
        case .cell(_, _, _, let didTap), .imageCell(_, _, _, _, _, _, _, let didTap), .detail(_, _, _, _, _, let didTap), .subtitle(_, _, _, _, let didTap), .textWithButton(_, _, let didTap), .view(_, _, let didTap), .actionRequired(_, _, _, _, let didTap), .batteryLevel(_, _, _, _, _, _, let didTap):
            didTap?()
        case .toggle, .checkmark, .radioButton, .radioPillButton, .checkboxButton:
            if let cell = tableView.cellForRow(at: indexPath) as? Toggleable {
                cell.toggleValue()
            }
        case .inputField, .slider, .timer, .urgentAction:
            break
        }
    }
}

#endif
