//
//  PrimaryCTAButton.swift
//  
//
//  Created by Maxamilian Litteral on 4/1/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public class CTAButton: IconTextButton {

    public enum Priority {
        case primary
        case secondary
        case tertiary
    }

    public enum Style {
        case `default`
        case alert
        case upsell
        case white
    }

    // MARK: - Properties

    public var priority: Priority {
        didSet {
            updateBackground()
            updateTitle()
            updateImage()
            invalidateIntrinsicContentSize()
        }
    }

    public var style: Style {
        didSet {
            updateBackground()
            updateTitle()
            updateImage()
        }
    }

    public var title: String? {
        didSet {
            updateTitle()
        }
    }

    public var disabledTitle: String? {
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

    public init(priority: Priority = .primary, style: Style = .default, title: String? = nil, image: UIImage? = nil) {
        self.priority = priority
        self.style = style
        self.title = title
        self.image = image

        super.init()

        setup()
    }

    public required init?(coder: NSCoder) {
        self.priority = .primary
        self.style = .default

        super.init(coder: coder)

        self.title = title(for: .normal)
        self.image = image(for: .normal)

        setup()
    }

    // MARK: - Overrides

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: max(44, super.intrinsicContentSize.width),
            height: priority.preferredHeight
        )
    }

    @available(*, unavailable)
    public override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
    }

    @available(*, unavailable, message: "Use the title and disabledTitle properties instead")
    public override func setTitle(_ title: String?, for state: UIControl.State) {
    }

    @available(*, unavailable, message: "Use the title and disabledTitle properties instead")
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

        layer.cornerRadius = 3
        layer.masksToBounds = true

        contentEdgeInsets = UIEdgeInsets(xInset: 24, yInset: 0)

        updateBackground()
        updateTitle()
        updateImage()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTitle),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    private func updateBackground() {
        let colorMode = priority.backgroundColorMode
        super.setBackgroundImage(colorMode.flatMap { .colored(style.color, mode: $0) }, for: .normal)
        super.setBackgroundImage(colorMode.flatMap { .colored(style.highlightedColor, mode: $0) }, for: .highlighted)
        super.setBackgroundImage(priority.disabledBackgroundColor.flatMap { .colored($0) }, for: .disabled)
    }

    @objc private func updateTitle() {
        var titleStyle = priority.titleStyle
        titleStyle.font = titleStyle.adaptedFont()

        super.setAttributedTitle(title?.styled(with: titleStyle.colored(priority.titleColor(for: style))), for: .normal)
        super.setAttributedTitle(title?.styled(with: titleStyle.colored(priority.highlightedTitleColor(for: style))), for: .highlighted)
        super.setAttributedTitle((disabledTitle ?? title)?.styled(with: titleStyle.colored(priority.disabledColor)), for: .disabled)
    }

    private func updateImage() {
        super.setImage(image?.tintedImage(color: priority.titleColor(for: style)), for: .normal)
        super.setImage(image?.tintedImage(color: priority.highlightedTitleColor(for: style)), for: .highlighted)
        super.setImage(image?.tintedImage(color: priority.disabledColor), for: .disabled)
    }

}

// MARK: - Styling

private extension CTAButton.Priority {

    var preferredHeight: CGFloat {
        switch self {
        case .primary, .secondary:
            return 56
        case .tertiary:
            return 44
        }
    }

    var titleStyle: StringStyle {
        switch self {
        case .primary, .secondary:
            return StringStyle.button1.byAdding(.transform(.uppercase))
        case .tertiary:
            return StringStyle.button1.byAdding(.transform(.capitalized))
        }
    }

    var backgroundColorMode: UIImage.ColoringMode? {
        switch self {
        case .primary:
            return .fill
        case .secondary:
            return .stroke(width: 2)
        case .tertiary:
            return nil
        }
    }

    var disabledColor: UIColor {
        switch self {
        case .primary, .secondary:
            return UIColor.SS.Grey.medium
        case .tertiary:
            return UIColor.SS.Grey.light
        }
    }

    var disabledBackgroundColor: UIColor? {
        switch self {
        case .primary, .secondary:
            return UIColor.SS.Grey.basic
        case .tertiary:
            return nil
        }
    }

    func titleColor(for style: CTAButton.Style) -> UIColor {
        switch self {
        case .primary:
            return style == .white ? UIColor.SS.Grey.dark : UIColor.SS.Grey.white
        case .secondary, .tertiary:
            return style.color
        }
    }

    func highlightedTitleColor(for style: CTAButton.Style) -> UIColor {
        switch self {
        case .primary:
            return titleColor(for: style)
        case .secondary, .tertiary:
            return style.highlightedColor
        }
    }

}

private extension CTAButton.Style {

    var color: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Slate.base
        case .alert:
            return UIColor.SS.Red.base
        case .upsell:
            return UIColor.SS.Blue.base
        case .white:
            return UIColor.SS.Grey.white
        }
    }

    var highlightedColor: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Slate.dark
        case .alert:
            return UIColor.SS.Red.dark
        case .upsell:
            return UIColor.SS.Blue.dark
        case .white:
            return UIColor.SS.Grey.light
        }
    }

}

#endif
