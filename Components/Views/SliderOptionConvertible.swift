//
//  SliderOptionConvertible.swift
//  
//
//  Created by Maxamilian Litteral on 2/11/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public protocol SliderOptionConvertible {
    typealias Note = (image: UIImage?, text: String?)

    var title: String { get }
    var description: String? { get }
    var image: UIImage? { get }
    var imageCaption: String? { get }
    var note: Note? { get }
}

#endif
