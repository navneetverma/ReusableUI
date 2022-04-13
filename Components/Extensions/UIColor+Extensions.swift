//
//  UIColor+Extensions.swift
//  
//
//  Created by Maxamilian Litteral on 12/12/19.
//

#if canImport(UIKit)
import UIKit

public extension UIColor {
    convenience init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        if hexString.count != 6 {
            fatalError("The color hex code should be 6 chars in length.")
        }

        var rgbValue: UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: CGFloat(1.0))
    }

    func darker(by offset: CGFloat = 0.2) -> UIColor {
        let offset = abs(offset)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: max(r - offset, 0), green: max(g - offset, 0), blue: max(b - offset, 0), alpha: a)
        }

        return self
    }

    func lighter(by offset: CGFloat = 0.2) -> UIColor {
        let offset = abs(offset)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: min(r + offset, 1.0), green: min(g + offset, 1.0), blue: min(b + offset, 1.0), alpha: a)
        }

        return self
    }

    /// Colors match documentation by Rob & Nadeem
    /// https://docs.google.com/spreadsheets/d/1dFOIUlZoirUh0xjS7Jy9Ymr7BOzglOSoVqpyv1PMKQw/edit#gid=0
    /// and Sketch
    enum SS {
        public enum Blue {
            public static let base = UIColor(hex: "008CC1")
            public static let light = UIColor(hex: "66BADA")
            public static let dark = UIColor(hex: "00658B")
            public static let grey = UIColor(hex: "415364")
        }

        /// In order of shade light to dark
        public enum Grey {
            public static let white = UIColor(hex: "FFFFFF")
            public static let cool = UIColor(hex: "F6F6F5")
            public static let smoke = UIColor(hex: "F1F3F4")
            public static let basic = UIColor(hex: "D5D8D9")
            public static let light = UIColor(hex: "C4C7C9")
            public static let medium = UIColor(hex: "9D9CA0")
            public static let dark = UIColor(hex: "51545D")
            public static let alt1 = UIColor(hex: "F9F9F9")
            public static let alt2 = UIColor(hex: "E5E6E6")
            public static let lockWall = UIColor(hex: "ECEBE9")
        }

        public enum Slate {
            public static let base = UIColor(hex: "415364")
            public static let dark = UIColor(hex: "213242")
            public static let midnight = UIColor(hex: "2B2F35")
        }

        public enum Red {
            public static let base = UIColor(hex: "EE5800")
            public static let light = UIColor(hex: "FB8265")
            public static let dark = UIColor(hex: "CD4C00")
        }

        public enum Yellow {
            public static let base = UIColor(hex: "EAA400")
        }
    }

    static let defaultTextColor = SS.Grey.dark

    static let AppTintColor = SS.Blue.base
    static let ViewBackgroundColor = SS.Grey.cool
    static let TableViewBackgroundColor = SS.Grey.cool
    static let TableViewHeaderColor = SS.Grey.medium
    static let ErrorColor = SS.Red.base
    static let VideoBackgroundColor = UIColor(hex: "31373F")

    static var allColors: [UIColor] = [
        UIColor.SS.Blue.base,
        UIColor.SS.Blue.light,
        UIColor.SS.Blue.dark,
        UIColor.SS.Blue.grey,

        UIColor.SS.Grey.white,
        UIColor.SS.Grey.cool,
        UIColor.SS.Grey.smoke,
        UIColor.SS.Grey.basic,
        UIColor.SS.Grey.light,
        UIColor.SS.Grey.medium,
        UIColor.SS.Grey.dark,
        UIColor.SS.Grey.alt1,
        UIColor.SS.Grey.alt2,
        UIColor.SS.Grey.lockWall,

        UIColor.SS.Slate.base,
        UIColor.SS.Slate.dark,
        UIColor.SS.Slate.midnight,

        UIColor.SS.Red.base,
        UIColor.SS.Red.light,
        UIColor.SS.Red.dark,

        UIColor.SS.Yellow.base,
        VideoBackgroundColor
    ]
}

#endif
