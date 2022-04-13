//
//  RadioOptionContainer.swift
//  
//
//  Created by Rob Visentin on 1/21/21.
//

import Foundation

public protocol RadioOptionContainer: Toggleable {

    var isToggleSelected: Bool { get set }

    func configure(with option: RadioOptionConvertible)

}

public extension RadioOptionContainer {

    func toggleValue() {
        isToggleSelected.toggle()
        toggleAction?(isToggleSelected)
    }

}
