//
//  UILabel+Extensions.swift
//  
//
//  Created by Siddarth Gandhi on 5/19/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public extension UILabel {
    convenience init(style: StringStyle, text: String? = nil, image: UIImage? = nil, imageTintColor: UIColor? = nil) {
        self.init()

        translatesAutoresizingMaskIntoConstraints = false
        bonMotStyle = style

        if let image = image {
            var imageStyle = StringStyle(.baselineOffset(-4))
            imageStyle.color = imageTintColor

            attributedText = NSAttributedString.composed(of: ([
                image.styled(with: imageStyle),
                Tab.headIndent(6),
                text?.styled(with: style)
            ] as [Composable?]).compactMap { $0 })
        } else {
            styledText = text
        }
    }
}

#endif
