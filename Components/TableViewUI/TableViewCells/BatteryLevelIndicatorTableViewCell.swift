//
//  BatteryLevelIndicatorTableViewCell.swift
//  
//
//  Created by Siddarth Gandhi on 10/13/20.
//

import Foundation

#if canImport(UIKit)

import UIKit

/// Sensor battery levels with images
public enum BatteryLevel {
    case empty, low, medium, high, full, charging

    public var image: UIImage? {
        switch self {
        case .empty:
            return UIImage(named: "BatteryEmpty", in: .module, compatibleWith: nil)
        case .low:
            return UIImage(named: "BatteryLow", in: .module, compatibleWith: nil)
        case .medium:
            return UIImage(named: "BatteryMedium", in: .module, compatibleWith: nil)
        case .high:
            return UIImage(named: "BatteryHigh", in: .module, compatibleWith: nil)
        case .full:
            return UIImage(named: "BatteryFull", in: .module, compatibleWith: nil)
        case .charging:
            return UIImage(named: "BatteryCharging", in: .module, compatibleWith: nil)
        }
    }
}

/// Table view cell with a battery level image on the right
open class BatteryLevelIndicatorTableViewCell: ImageCell {

    // MARK: - Properties

    var batteryLevel: BatteryLevel? {
        didSet {
            trailingImage = batteryLevel?.image
        }
    }

}

#endif
