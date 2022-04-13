//
//  PillButton.swift
//  
//
//  Created by Sindhu Majeti on 11/9/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class PillButton: IconTextButton {

    public enum Style {
        case `default`
        case alert
        case upsell
    }

    private enum Constants {
        static let preferredHeight: CGFloat = 36
        static let alpha: CGFloat = 0.1
        static let higlightedAlpha: CGFloat = 0.2
        static let titleStyle = StringStyle.button1.byAdding(.transform(.capitalized))
    }

    // MARK: - Properties

    public var style: Style {
        didSet {
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

    public init(style: Style = .default, title: String? = nil, image: UIImage? = nil) {
        self.style = style
        self.title = title
        self.image = image

        super.init()

        setup()
    }

    public required init?(coder: NSCoder) {
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
            height: Constants.preferredHeight
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

        contentEdgeInsets = UIEdgeInsets(xInset: 16, yInset: 0)

        super.setBackgroundImage(.colored(UIColor.SS.Slate.base.withAlphaComponent(Constants.alpha), cornerRadius: 0.5 * Constants.preferredHeight), for: .normal)
        super.setBackgroundImage(.colored(UIColor.SS.Slate.base.withAlphaComponent(Constants.higlightedAlpha), cornerRadius: 0.5 * Constants.preferredHeight), for: .highlighted)

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
        var titleStyle = Constants.titleStyle
        titleStyle.font = titleStyle.adaptedFont()

        super.setAttributedTitle(title?.styled(with: titleStyle.colored(style.color)), for: .normal)
        super.setAttributedTitle(title?.styled(with: titleStyle.colored(style.highlightedColor)), for: .highlighted)
        super.setAttributedTitle((disabledTitle ?? title)?.styled(with: titleStyle.colored(style.disabledColor)), for: .disabled)
    }

    private func updateImage() {
        super.setImage(image?.tintedImage(color: style.color), for: .normal)
        super.setImage(image?.tintedImage(color: style.highlightedColor), for: .highlighted)
        super.setImage(image?.tintedImage(color: style.disabledColor), for: .disabled)
    }

}

// MARK: - Styling

private extension PillButton.Style {

    var color: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Slate.base
        case .alert:
            return UIColor.SS.Red.base
        case .upsell:
            return UIColor.SS.Blue.base
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
        }
    }

    var disabledColor: UIColor {
        UIColor.SS.Grey.light
    }

}

#endif
