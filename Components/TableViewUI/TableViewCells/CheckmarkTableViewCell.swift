//
//  CheckmarkTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 12/11/19.
//

#if canImport(UIKit)
import UIKit

/// Table view cell with a checkmark
public class CheckmarkTableViewCell: TitleTableViewCell, Toggleable {

    // MARK: - Properties

    public var toggleAction: ToggleAction?

    public var isCheckmarked: Bool = false {
        didSet {
            accessoryType = isCheckmarked ? .checkmark : .none
        }
    }

    // MARK: - Lifecycle

    public override func prepareForReuse() {
        super.prepareForReuse()
        isCheckmarked = false
    }
    
    // MARK: - Actions

    // MARK: - Toggleable

    public func toggleValue() {
        self.isCheckmarked.toggle()
        toggleAction?(self.isCheckmarked)
    }
}

#endif
