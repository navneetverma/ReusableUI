//
//  Inputable.swift
//  
//
//  Created by Maxamilian Litteral on 12/12/19.
//

import Foundation

#if canImport(UIKit)
public protocol Inputable {
    var inputAction: TextInputAction? { get set }
    var returnAction: TextInputDidReturn? { get set }
    func beginInput()
    func endInput()
}
#endif
