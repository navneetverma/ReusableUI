//
//  RadioButtonTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 1/22/20.
//

#if canImport(UIKit)
import UIKit

public class RadioButtonTableViewCell: ToggleableTableviewCell<RadioButton>, RadioOptionContainer {

    public func configure(with option: RadioOptionConvertible) {
        title = option.title
        detailText = option.description
    }

}

#endif
