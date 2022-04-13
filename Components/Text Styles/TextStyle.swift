//
//  TextStyle.swift
//  
//
//  Created by Siddarth Gandhi on 5/15/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public extension StringStyle {
    static let headline1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 26, weight: .light)),
            .color(.defaultTextColor),
            .minimumLineHeight(30)
        )
        NamedStyles.shared.registerStyle(forName: "headline1", style: style)
        return style
    }()

    static let headline2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 20, weight: .regular)),
            .color(.defaultTextColor),
            .minimumLineHeight(25)
        )
        NamedStyles.shared.registerStyle(forName: "headline2", style: style)
        return style
    }()

    static let title1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 20, weight: .light)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "title1", style: style)
        return style
    }()

    static let title2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 16, weight: .regular)),
            .color(.defaultTextColor),
            .minimumLineHeight(20)
        )
        NamedStyles.shared.registerStyle(forName: "title2", style: style)
        return style
    }()

    static let title3: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .medium)),
            .color(.defaultTextColor),
            .minimumLineHeight(18)
        )
        NamedStyles.shared.registerStyle(forName: "title3", style: style)
        return style
    }()

    static let title4: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 12, weight: .regular)),
            .color(.defaultTextColor),
            .transform(.uppercase)
        )
        NamedStyles.shared.registerStyle(forName: "title4", style: style)
        return style
    }()

    static let body1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 16, weight: .light)),
            .color(.defaultTextColor),
            .minimumLineHeight(20)
        )
        NamedStyles.shared.registerStyle(forName: "body1", style: style)
        return style
    }()

    static let body2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 16, weight: .regular)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "body2", style: style)
        return style
    }()

    static let body3: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .regular)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "body3", style: style)
        return style
    }()

    static let body4: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .light)),
            .minimumLineHeight(18),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "body4", style: style)
        return style
    }()

    static let label1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .regular)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "label1", style: style)
        return style
    }()

    static let label2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .regular)),
            .color(.defaultTextColor),
            .minimumLineHeight(18),
            .transform(.uppercase)
        )
        NamedStyles.shared.registerStyle(forName: "label2", style: style)
        return style
    }()

    static let label3: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 12, weight: .medium)),
            .color(.defaultTextColor)
        )

        NamedStyles.shared.registerStyle(forName: "label3", style: style)
        return style
    }()
    static let label4: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 10, weight: .regular)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "label4", style: style)
        return style
    }()

    static let message1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 12, weight: .light)),
            .minimumLineHeight(16),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "message1", style: style)
        return style
    }()

    static let message2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 12, weight: .regular)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "message2", style: style)
        return style
    }()

    static let button1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 16, weight: .medium)),
            .color(.defaultTextColor)
        )
        NamedStyles.shared.registerStyle(forName: "button1", style: style)
        return style
    }()

    static let link1: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 16, weight: .regular)),
            .color(UIColor.SS.Blue.base),
            .underline(.single, UIColor.SS.Blue.base)
        )
        NamedStyles.shared.registerStyle(forName: "link1", style: style)
        return style
    }()

    static let link2: StringStyle = {
        let style = StringStyle(
            .font(UIFont.SS.font(size: 14, weight: .regular)),
            .color(UIColor.SS.Blue.base),
            .underline(.single, UIColor.SS.Blue.base)
        )
        NamedStyles.shared.registerStyle(forName: "link2", style: style)
        return style
    }()
}

public extension StringStyle {
    func byAdding(_ part: StringStyle.Part, toXmlTag xmlTag: String) -> StringStyle {
        byAdding(.xmlRules([
            .style(xmlTag, byAdding(part))
        ]))
    }

    func colored(_ color: UIColor, xmlTag: String? = nil) -> StringStyle {
        var coloredStyle = byAdding(.color(color))

        if let strikethrough = coloredStyle.strikethrough {
            coloredStyle.strikethrough = (strikethrough.0, color)
        }

        if let underline = coloredStyle.underline {
            coloredStyle.underline = (underline.0, color)
        }

        return coloredStyle
    }

    func aligned(_ alignment: NSTextAlignment) -> StringStyle {
        byAdding(.alignment(alignment))
    }

    func weighted(_ weight: UIFont.SS.Weight, xmlTag: String? = nil) -> StringStyle {
        let weightedStyle = font.map { byAdding(.font(UIFont.SS.font(size: $0.pointSize, weight: weight))) } ?? self

        // Only apply the weight to text delimited by the given xml tag
        if let xmlTag = xmlTag {
            return byAdding(.xmlRules([.style(xmlTag, weightedStyle)]))
        }

        // Or apply the weight to the whole style if no tag is specified
        return weightedStyle
    }

    func adapted(_ style: AdaptiveStyle = .control) -> StringStyle {
        byAdding(.adapt(style))
    }

    func adaptedFont(_ style: AdaptiveStyle = .control) -> UIFont? {
        font.map {
            UIFont(
                descriptor: $0.fontDescriptor,
                size: AdaptiveStyle.adapt(designatedSize: $0.pointSize, for: UIApplication.shared.preferredContentSizeCategory)
            )
        }
    }
}

#endif
