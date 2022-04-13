//
//  ChipButton.swift
//  
//
//  Created by Vishwanath Deshmukh on 3/16/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class Chip: IconTextButton {

    // MARK: - Properties

    public enum Style {
        case `default`
        case alert
        case upsell
        case gray
        case yellow
    }

    private enum Constants {
        static let preferredHeight: CGFloat = 18
        static let cornerRadius =  0.5 * preferredHeight
    }

    public var titleStyle: StringStyle = StringStyle.label4.byAdding(.transform(.uppercase)) {
        didSet {
            updateTitle()
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

    public init(style: Style = .default, title: String? = nil, image: UIImage? = nil) {
        self.style = style
        self.title = title
        self.image = image
        super.init()
        isUserInteractionEnabled = false
        setup()
    }

    public required init?(coder: NSCoder) {
        self.style = .default
        super.init(coder: coder)
        self.title = title(for: .normal)
        self.image = image(for: .normal)
        isUserInteractionEnabled = false
        setup()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: max(44, super.intrinsicContentSize.width),
               height: Constants.preferredHeight)
    }

    // MARK: - Setup

    private func setup() {
        contentEdgeInsets = UIEdgeInsets(xInset: 12, yInset: 0)
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
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
        contentEdgeInsets = UIEdgeInsets(xInset: 16, yInset: 0)
        super.setBackgroundImage(.colored(style.backgroundColor, cornerRadius: Constants.cornerRadius), for: .normal)
        super.setBackgroundImage(.colored(style.highlightedColor, cornerRadius: Constants.cornerRadius), for: .highlighted)
    }

    @objc private func updateTitle() {
        var titleStyle = self.titleStyle
        titleStyle.font = titleStyle.adaptedFont()

        super.setAttributedTitle(title?.styled(with: titleStyle.colored(style.textColor)), for: .normal)
        super.setAttributedTitle((disabledTitle ?? title)?.styled(with: titleStyle.colored(style.disabledColor)), for: .disabled)
    }

    private func updateImage() {
        super.setImage(image?.tintedImage(color: style.textColor), for: .normal)
        super.setImage(image?.tintedImage(color: style.disabledColor), for: .disabled)
    }
}

// MARK: - Styling

private extension Chip.Style {

    // MARK: - Properties

    var textColor: UIColor {
        switch self {
        case .gray:
            return UIColor.SS.Grey.dark
        default:
            return UIColor.white
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Slate.base
        case .alert:
            return UIColor.SS.Red.base
        case .upsell:
            return UIColor.SS.Blue.base
        case .gray:
            return UIColor.SS.Grey.basic
        case .yellow:
            return UIColor.SS.Yellow.base
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
        case .gray:
            return UIColor.SS.Grey.dark
        case .yellow:
            return UIColor.SS.Yellow.base.withAlphaComponent(0.9)

        }
    }

    var disabledColor: UIColor {
        UIColor.SS.Grey.light
    }
}
#endif
