//
//  File.swift
//  
//
//  Created by Maxamilian Litteral on 1/4/21.
//

import Foundation

#if canImport(UIKit)
import UIKit

/// https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0
/// Update if we ever support multiple scenes. isKeyWindow shouldn't be used with multiple scenes
extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
#endif
