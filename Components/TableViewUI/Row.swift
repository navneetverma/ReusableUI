//
//  Rows.swift
//  
//
//  Created by Maxamilian Litteral on 12/16/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

public typealias Action = (() -> Void)
public typealias ToggleAction = ((Bool) -> Void)
public typealias ToggleValue = () -> Bool
public typealias ToggleState = () -> String
public typealias TextInputAction = (String?) -> Void
public typealias TextInputDidReturn = () -> Void
public typealias TextInputValue = () -> String?
public typealias SliderValue = () -> Int
public typealias SliderAction = (Int) -> Void
public typealias TimerValue = () -> TimeInterval
public typealias TimerAction = (TimeInterval) -> Void

public enum Row {
    case cell(title: String, accessory: UITableViewCell.AccessoryType = .none, configuration: ((UITableViewCell) -> Void)? = nil, didTap: Action? = nil)
    case imageCell(title: String, subtitle: String?, accessory: UITableViewCell.AccessoryType = .none, configuration: ((UITableViewCell) -> Void)? = nil, leadingImage: UIImage?, trailingImage: UIImage?, tintColor: UIColor?, didTap: Action? = nil)
    case detail(title: String, subtitle: String? = nil, detail: String, configuration: ((UITableViewCell) -> Void)? = nil, accessory: UITableViewCell.AccessoryType = .none, didTap: Action? = nil)
    case subtitle(title: String, detail: String, configuration: ((UITableViewCell) -> Void)? = nil, accessory: UITableViewCell.AccessoryType = .none, didTap: Action? = nil)
    case checkmark(title: String, value: ToggleValue, didToggle: ToggleAction? = nil)
    case toggle(title: String, state: ToggleState? = nil, rowSubview: RowSubview? = nil, value: ToggleValue, didToggle: ToggleAction? = nil)
    case inputField(title: String, value: TextInputValue, textDidChange: TextInputAction? = nil, returnAction: TextInputDidReturn? = nil, configuration: ((TextInputTableViewCell) -> Void)? = nil)
    case textWithButton(title: String, buttonTitle: String, didTap: Action? = nil)
    case view(type: UITableViewCell.Type, configuration: ((UITableViewCell) -> Void), didTap: Action? = nil)
    case radioButton(title: String, detail: String?, value: ToggleValue, didToggle: ToggleAction? = nil)
    case radioPillButton(title: String, value: ToggleValue, didToggle: ToggleAction? = nil)
    case checkboxButton(title: String, detail: String?, value: ToggleValue, didToggle: ToggleAction? = nil)
    case slider(title: String, detail: String?, options: [SliderOptionConvertible], value: SliderValue, didSelect: SliderAction, configuration: ((SliderTableViewCell) -> Void)? = nil)
    case timer(title: String, detail: String?, range: ClosedRange<TimeInterval>, step: TimeInterval, currentValue: TimerValue, durationDidChange: TimerAction)
    case actionRequired(title: String, subtitle: String, actionRequired: Bool, accessory: UITableViewCell.AccessoryType, didTap: Action? = nil)
    case urgentAction(text: String, actionTitle: String, buttonAction: Action? = nil)
    case batteryLevel(title: String, subtitle: String?, batteryLevel: BatteryLevel, accessory: UITableViewCell.AccessoryType = .none, configuration: ((UITableViewCell) -> Void)? = nil, leadingImage: UIImage?, didTap: Action? = nil)

    var cellType: UITableViewCell.Type {
        switch self {
        case .cell:
            return TitleTableViewCell.self
        case .imageCell:
            return ImageCell.self
        case .detail:
            return RightDetailTableViewCell.self
        case .subtitle:
            return SubtitleTableViewCell.self
        case .checkmark:
            return CheckmarkTableViewCell.self
        case .toggle:
            return ToggleTableViewCell.self
        case .inputField:
            return TextInputTableViewCell.self
        case .textWithButton:
            return TextWithButtonTableViewCell.self
        case .view(let rowType, _, _):
            return rowType
        case .radioButton:
            return RadioButtonTableViewCell.self
        case .radioPillButton:
            return RadioPillButtonTableViewCell.self
        case .checkboxButton:
            return CheckboxButtonTableViewCell.self
        case .slider:
            return SliderTableViewCell.self
        case .timer:
            return TimerTableViewCell.self
        case.actionRequired:
            return ActionRequiredCell.self
        case .urgentAction:
            return UrgentActionCell.self
        case .batteryLevel:
            return BatteryLevelIndicatorTableViewCell.self
        }
    }

    var cellIdentifier: String {
        return cellType.identifier
    }
}
#endif
