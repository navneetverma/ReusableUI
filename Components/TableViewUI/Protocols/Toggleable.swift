//
//  Toggleable.swift
//  
//
//  Created by Maxamilian Litteral on 12/11/19.
//

import Foundation

#if canImport(UIKit)
public protocol Toggleable: AnyObject {
    var toggleAction: ToggleAction? { get set }
    func toggleValue()
}
#endif
