//
//  LinkButton.swift
//  
//
//  Created by Maxamilian Litteral on 1/20/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public final class LinkButton: IconTextButton {

    public typealias Label = (text: String, position: LabelPosition)

    public enum Style {
        case `default`
        case white
    }

    public enum Size {
        case `default`
        case small
    }

    public enum LabelPosition {
        case inline
        case stacked
    }

    private enum Constants {
        static let linkTag = "li"
        static let labelTag = "la"
    }

    // MARK: - Properties

    public var style: Style {
        didSet {
            updateTitle()
            updateImage()
        }
    }

    public var size: Size {
        didSet {
            updateTitle()
        }
    }

    public var link: String? {
        didSet {
            updateTitle()
        }
    }

    public var label: Label? {
        didSet {
            updateTitle()
        }
    }

    public var image: UIImage? {
        didSet {
            updateImage()
        }
    }

    // MARK: - Lifecycle

    public init(style: Style = .default, size: Size = .default, link: String? = nil, label: Label? = nil, image: UIImage? = nil) {
        self.style = style
        self.size = size
        self.link = link
        self.label = label
        self.image = image

        super.init()

        setup()
    }

    public required init?(coder: NSCoder) {
        self.style = .default
        self.size = .default

        super.init(coder: coder)

        self.link = title(for: .normal)
        self.image = image(for: .normal)

        setup()
    }

    // MARK: - Overrides

    @available(*, unavailable)
    public override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
    }

    @available(*, unavailable, message: "Use the link and label properties instead")
    public override func setTitle(_ title: String?, for state: UIControl.State) {
    }

    @available(*, unavailable, message: "Use the link and label properties instead")
    public override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
    }

    @available(*, unavailable)
    public override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
    }

    @available(*, unavailable)
    public override func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) {
    }

    @available(*, unavailable, message: "Use the image property instead")
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
    }

    // MARK: - Actions

    private func setup() {
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false

        updateTitle()
        updateImage()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTitle),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func updateTitle() {
        var linkStyle = size.linkStyle
        linkStyle.font = linkStyle.adaptedFont()

        var labelStyle = size.labelStyle
        labelStyle.font = labelStyle.adaptedFont()

        let titleComponents = [
            label.map { "<\(Constants.labelTag)>\($0.text)</\(Constants.labelTag)>" },
            link.map { "<\(Constants.linkTag)>\($0)</\(Constants.linkTag)>" }
        ].compactMap { $0 }

        let title = titleComponents.isEmpty ? nil : titleComponents.joined(separator: label?.position.separator ?? "")

        let normalStyle = StringStyle(.xmlRules([
            .style(Constants.linkTag, linkStyle.colored(style.linkColor)),
            .style(Constants.labelTag, labelStyle.colored(style.labelColor))
        ]), .alignment(.center))

        let highlightedStyle = StringStyle(.xmlRules([
            .style(Constants.linkTag, linkStyle.colored(style.highlightedLinkColor)),
            .style(Constants.labelTag, labelStyle.colored(style.labelColor))
        ]), .alignment(.center))

        let disabedStyle = StringStyle(.xmlRules([
            .style(Constants.linkTag, linkStyle.colored(style.disabledColor)),
            .style(Constants.labelTag, labelStyle.colored(style.disabledColor))
        ]), .alignment(.center))

        super.setAttributedTitle(title?.styled(with: normalStyle), for: .normal)
        super.setAttributedTitle(title?.styled(with: highlightedStyle), for: .highlighted)
        super.setAttributedTitle(title?.styled(with: disabedStyle), for: .disabled)

        titleLabel?.numberOfLines = label?.position.numberOfLines ?? 1
    }

    private func updateImage() {
        iconSize = size.imageSize

        super.setImage(image?.tintedImage(color: style.linkColor), for: .normal)
        super.setImage(image?.tintedImage(color: style.highlightedLinkColor), for: .highlighted)
        super.setImage(image?.tintedImage(color: style.disabledColor), for: .disabled)
    }

}

// MARK: - Styling

private extension LinkButton.Style {

    var linkColor: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Blue.base
        case .white:
            return UIColor.SS.Grey.white
        }
    }

    var highlightedLinkColor: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Blue.dark
        case .white:
            return UIColor.SS.Grey.basic
        }
    }

    var labelColor: UIColor {
        switch self {
        case .default:
            return .defaultTextColor
        case .white:
            return UIColor.SS.Grey.white
        }
    }

    var disabledColor: UIColor {
        UIColor.SS.Grey.light
    }

}

private extension LinkButton.Size {

    var imageSize: IconTextButton.ImageSize {
        switch self {
        case .default:
            return .default
        case .small:
            return .small
        }
    }

    var linkStyle: StringStyle {
        switch self {
        case .default:
            return .link1
        case .small:
            return .link2
        }
    }

    var labelStyle: StringStyle {
        var style = StringStyle.title2
        style.minimumLineHeight = nil
        return style
    }

}

private extension LinkButton.LabelPosition {

    var separator: String {
        switch self {
        case .inline:
            return Special.space.description
        case .stacked:
            return Special.nextLine.description
        }
    }

    var numberOfLines: Int {
        switch self {
        case .inline:
            return 1
        case .stacked:
            return 0
        }
    }

}

#endif
