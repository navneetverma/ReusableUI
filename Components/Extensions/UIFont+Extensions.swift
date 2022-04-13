//
//  UIFont+Extensions.swift
//
//
//  Created by Maxamilian Litteral on 1/22/20.
//

#if canImport(UIKit)
import UIKit

public extension UIFont {
    enum SS {
        public enum Weight {
            case light
            case medium
            case regular
            case ultraLight
        }

        public static func font(size: CGFloat, weight: Weight = .regular) -> UIFont {
            UIFont(name: weight.name, size: size)!
        }
    }

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { fatalError("Could not build font description") }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

private extension UIFont.SS.Weight {
    var name: String {
        switch self {
        case .light:
            return UIFont.SS.lightName
        case .medium:
            return UIFont.SS.mediumName
        case .regular:
            return UIFont.SS.regularName
        case .ultraLight:
            return UIFont.SS.ultraLightName
        }
    }
}

private extension UIFont.SS {
    static let lightName: String = {
        let name = "DINNextLTPro-Light"
        registerFont(named: name)
        return name
    }()

    static let mediumName: String = {
        let name = "DINNextLTPro-Medium"
        registerFont(named: name)
        return name
    }()

    static let regularName: String = {
        let name = "DINNextLTPro-Regular"
        registerFont(named: name)
        return name
    }()

    static let ultraLightName: String = {
        let name = "DINNextLTPro-UltraLight"
        registerFont(named: name)
        return name
    }()

    static func registerFont(named fontName: String) {
        if let fontURL = Bundle.module.url(forResource: fontName, withExtension: "otf") as NSURL? {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
}

#endif
