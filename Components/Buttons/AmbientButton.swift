//
//  AmbientButton.swift
//  
//
//  Created by Maxamilian Litteral on 4/2/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

public class AmbientButton: UIButton {

    public enum Style {
        case `default`
        case dismiss
        case white
    }

    private enum Constants {
        static let titleStyle = StringStyle.button1.byAdding(.transform(.uppercase))
    }

    // MARK: - Properties

    public var style: Style {
        didSet {
            updateTitle()
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

    // MARK: - Lifecycle

    public init(style: Style = .default, title: String? = nil) {
        self.style = style
        self.title = title

        super.init(frame: .zero)

        setup()
    }

    public required init?(coder: NSCoder) {
        self.style = .default

        super.init(coder: coder)

        self.title = title(for: .normal)

        setup()
    }

    // MARK: - Overrides

    @available(*, unavailable, message: "AmbientButton doesn't support background images")
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

    @available(*, unavailable, message: "AmbientButton doesn't support images")
    public override func setImage(_ image: UIImage?, for state: UIControl.State) {
    }

    // MARK: - Actions

    private func setup() {
        updateTitle()

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

}

// MARK: - Styling

private extension AmbientButton.Style {

    var color: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Blue.base
        case .dismiss:
            return UIColor.SS.Grey.medium
        case .white:
            return UIColor.SS.Grey.white
        }
    }

    var highlightedColor: UIColor {
        switch self {
        case .default:
            return UIColor.SS.Blue.dark
        case .dismiss:
            return UIColor.SS.Grey.dark
        case .white:
            return UIColor.SS.Grey.basic
        }
    }

    var disabledColor: UIColor {
        UIColor.SS.Grey.light
    }

}

#endif
