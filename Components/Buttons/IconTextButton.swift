//
//  IconTextButton.swift
//  
//
//  Created by Rob Visentin on 2/22/21.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class IconTextButton: UIButton {

    public enum ImageSize: CGFloat {
        case `default` = 24
        case small = 16
    }

    private enum Constants {
        static let imageSpacing: CGFloat = 8
    }

    // MARK: - Properties

    var iconSize: ImageSize = .default {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    private var imageSize: CGSize? {
        guard let image = image(for: state) else { return nil }

        let height = min(image.size.height, iconSize.rawValue)
        let width = min(image.aspectRatio * height, iconSize.rawValue)

        return CGSize(width: width, height: height)
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Overrides

    @available(*, unavailable, message: "IconTextButton uses constant image and title spacing")
    override public var imageEdgeInsets: UIEdgeInsets { didSet {} }

    @available(*, unavailable, message: "IconTextButton uses constant image and title spacing")
    override public var titleEdgeInsets: UIEdgeInsets { didSet {} }

    @available(*, unavailable, message: "IconTextButton is centered horizontally")
    override public var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment { didSet {} }

    @available(*, unavailable, message: "IconTextButton is centered vertically")
    public override var contentVerticalAlignment: UIControl.ContentVerticalAlignment { didSet {} }

    public override var intrinsicContentSize: CGSize {
        let titleArea = titleRect(forContentRect: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let imageWidth = imageSize.map { $0.width + Constants.imageSpacing } ?? 0

        return CGSize(
            width: ceil(contentEdgeInsets.horizontal + imageWidth + titleArea.width),
            height: ceil(contentEdgeInsets.vertical + max(imageSize?.height ?? 0, titleArea.height))
        )
    }

    public override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let size = imageSize ?? .zero
        var origin = CGPoint(
            x: contentRect.midX - 0.5 * size.width,
            y: contentRect.midY - 0.5 * size.height
        )

        let titleArea = titleRect(forContentRect: contentRect)

        if !titleArea.isEmpty {
            origin.x = titleArea.minX - Constants.imageSpacing - size.width
        }

        return CGRect(origin: origin, size: size)
    }

    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        guard let attributedTitle = attributedTitle(for: state) else {
            return CGRect(x: contentRect.midX, y: contentRect.midY, width: 0, height: 0)
        }

        let imageAreaWidth = imageSize.map { $0.width + Constants.imageSpacing } ?? 0
        var preferedTitleSize = attributedTitle.size()

        preferedTitleSize.width.round(.awayFromZero)
        preferedTitleSize.height.round(.awayFromZero)

        let size = CGSize(
            width: min(preferedTitleSize.width, contentRect.width - imageAreaWidth),
            height: min(preferedTitleSize.height, contentRect.height)
        )

        return CGRect(
            origin: CGPoint(
                x: contentRect.midX - 0.5 * size.width + 0.5 * imageAreaWidth,
                y: contentRect.midY - 0.5 * size.height
            ),
            size: size
        )
    }

    // MARK: - Actions

    private func setup() {
        imageView?.contentMode = .scaleAspectFit

        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

}

#endif
