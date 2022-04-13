//
//  UIImage+Extensions.swift
//  
//
//  Created by Rob Visentin on 11/13/20.
//

#if canImport(UIKit)
import UIKit

public extension UIImage {

    enum ColoringMode {
        case fill
        case stroke(width: CGFloat)
    }

    var aspectRatio: CGFloat {
        guard !size.height.isZero else {
            return 0
        }
        return size.width / size.height
    }

    static func colored(_ color: UIColor, cornerRadius: CGFloat = 0, mode: ColoringMode = .fill) -> UIImage? {
        let cornerRadius = max(0, cornerRadius)

        var padding = cornerRadius

        if case .stroke(let width) = mode {
            padding += width
        }

        let dim = 1 + 2 * padding
        let size = CGSize(width: dim, height: dim)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()

        if cornerRadius > 0 {
            ctx?.addPath(UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: size),
                byRoundingCorners: .allCorners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath)
            ctx?.clip()
        }

        switch mode {
        case .fill:
            ctx?.setFillColor(color.cgColor)
            ctx?.fill(CGRect(origin: .zero, size: size))
        case .stroke(let width):
            ctx?.setStrokeColor(color.cgColor)
            ctx?.setLineWidth(width)
            ctx?.stroke(CGRect(origin: .zero, size: size).insetBy(dx: 0.5 * width, dy: 0.5 * width))
        }

        var result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if padding > 0 {
            result = result?.stretchableImage(withLeftCapWidth: Int(padding), topCapHeight: Int(padding))
        }

        return result
    }

}
#endif
