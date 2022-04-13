//
//  RadioPillButton.swift
//  
//
//  Created by Rob Visentin on 1/20/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public final class RadioPillButton: UIButton, RadioOptionContainer {

    private enum Constants {
        static let borderWidth: CGFloat = 1
        static let selectedBorderWidth: CGFloat = 2
    }

    // MARK: - Properties

    public var isToggleSelected: Bool {
        get {
            return isSelected
        }
        set {
            isSelected = newValue
        }
    }

    public var toggleAction: ToggleAction?

    override public var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    public override var backgroundColor: UIColor? {
        didSet {
            setBackgroundImage(backgroundColor.flatMap { UIImage.colored($0) }, for: .normal)
        }
    }

    public override var intrinsicContentSize: CGSize {
        guard let title = currentTitle, let font = titleLabel?.font else {
            return super.intrinsicContentSize
        }

        // We want to avoid changing the size of the button when style changes between regular and bold
        // Compute intrinsic size based on the larger (bold) title
        let boldTitle = NSMutableAttributedString(string: title, attributes: [
            .font: UIFont.SS.font(size: font.pointSize, weight: .medium)
        ])

        let border = max(Constants.borderWidth, Constants.selectedBorderWidth)

        var size = boldTitle.size()
        size.width += (contentEdgeInsets.left + contentEdgeInsets.right + border)
        size.height += (contentEdgeInsets.top + contentEdgeInsets.bottom + border)

        return size
    }

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0.5 * min(frame.width, frame.height)
    }

    // MARK: - Setup

    private func setup() {
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        backgroundColor = .white
        clipsToBounds = true

        setTitleColor(UIColor.SS.Slate.base, for: .normal)
        setTitleColor(UIColor.SS.Slate.base.darker(), for: .highlighted)
        setTitleColor(UIColor.SS.Slate.base.darker(), for: [.selected, .highlighted])
        
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }

    // MARK: - Actions

    private func updateAppearance() {
        if isSelected {
            titleLabel?.font = StringStyle.title2.weighted(.medium).adaptedFont()
            layer.borderColor = UIColor.SS.Slate.base.cgColor
            layer.borderWidth = Constants.selectedBorderWidth
        } else {
            titleLabel?.font = StringStyle.title2.adaptedFont()
            layer.borderColor = UIColor.SS.Grey.light.cgColor
            layer.borderWidth = Constants.borderWidth
        }
        invalidateIntrinsicContentSize()
    }

    @objc private func touchUpInside() {
        toggleValue()
    }

    // MARK: - RadioOptionContainer

    public func configure(with option: RadioOptionConvertible) {
        setTitle(option.title, for: .normal)
    }

}

#endif
