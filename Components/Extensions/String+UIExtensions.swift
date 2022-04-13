//
//  File.swift
//  
//
//  Created by Robert Sparhawk on 1/28/20.
//

import Foundation
#if canImport(UIKit)
import BonMot
import UIKit

public extension String {
    enum StringImageAttachmentOrientation {
        case leading, trailing
    }
    
    // MARK: String manipulation


    /// Creates an attributed string with an image attached to the leading or trailing side.
    /// - Parameters:
    ///   - title: Text visible to users
    ///   - font: Font applied to the text
    ///   - image: Image that appears on the leading / trailing side of the title
    ///   - padding: Number of space characters between the title and image.
    ///   - tintColor: Color of the image and text
    ///   - location: Location of the image
    ///   - additionalAttributes: Additional attributes applied to the title
    /// - Returns: Attributed string for a label.
    static func stringWithAttachedImage(_ title: String, font: UIFont? = nil, image: UIImage, padding: Int = 2, tintColor: UIColor = UIColor.SS.Blue.base, location: StringImageAttachmentOrientation, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
        let returnString = title.withAttachment(image: image,
                                                orientation: location,
                                                padding: padding,
                                                imageTintColor: tintColor,
                                                textTintColor: tintColor,
                                                font: font)
        if let attributes = additionalAttributes {
            returnString.addAttributes(attributes, range: (returnString.string as NSString).range(of: title))
        }
        return returnString
    }

    func withAttachment(image: UIImage?, orientation: StringImageAttachmentOrientation, padding: Int, imageTintColor: UIColor?, textTintColor: UIColor?, font: UIFont?) -> NSMutableAttributedString {
        let labelFont = font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)

        guard let attachmentImage = image else {
            let returnString = NSMutableAttributedString(string: self)

            if let color = textTintColor {
                returnString.addAttributes([.foregroundColor : color], range: NSRange(location: 0, length: returnString.length))
            }

            returnString.addAttributes([.font : font ?? labelFont], range: NSRange(location: 0, length: returnString.length))

            return returnString
        }

        let attachmentString = NSMutableAttributedString.init(string: String.init(repeating: " ", count: padding))
        let attachment = NSTextAttachment()

        if imageTintColor != nil {
            attachment.image = attachmentImage.withRenderingMode(.alwaysTemplate)
        } else {
            attachment.image = attachmentImage
        }

        if let imageSize = attachment.image?.size {
            attachment.bounds = CGRect(x: CGFloat(0), y: (labelFont.capHeight - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        }

        let returnString = NSMutableAttributedString(string: self)
        var attachmentRange: NSRange?
        var textRange: NSRange?

        switch orientation {
        case .leading:
            attachmentString.insert(NSAttributedString(attachment: attachment), at: 0)
            if #available(iOS 13, *) { /* Bug fixed */ }
            else {
                attachmentString.insert(NSAttributedString(string: " "), at: 0)
            }
            attachmentRange = NSRange(location: 0, length: attachmentString.length)
            textRange = NSRange(location: attachmentString.length, length: returnString.length)
            returnString.insert(attachmentString, at: 0)
        case .trailing:
            attachmentString.insert(NSAttributedString(attachment: attachment), at: attachmentString.length)
            attachmentRange = NSRange(location: returnString.length, length: attachmentString.length)
            textRange = NSRange(location: 0, length: returnString.length)
            returnString.insert(attachmentString, at: returnString.length)
        }

        returnString.addAttributes([.font : labelFont], range: NSRange(location: 0, length: returnString.length))

        if let range = attachmentRange, let color = imageTintColor {
            returnString.addAttributes([.foregroundColor : color], range: range)
        }

        if let range = textRange, let color = textTintColor {
            returnString.addAttributes([.foregroundColor : color], range: range)
        }

        return returnString
    }
}
#endif
