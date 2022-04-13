//
//  CheckBoxButton.swift
//  
//
//  Created by Maxamilian Litteral on 1/23/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public final class CheckBoxButton: UIButton {

    // MARK: - Properties

    private let outerBoxLayer = CAShapeLayer()
    private let checkmarkLayer = CAShapeLayer()

    public override var isSelected: Bool {
        didSet {
            updateFillState()
        }
    }

    @IBInspectable public var outerBoxLineWidth: CGFloat = 1.0 {
        didSet {
            setBoxLayouts()
        }
    }

    private var cornerRadius: CGFloat = 2

    private var boxPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }

    private var checkmarkPath: UIBezierPath {
        let inset: CGFloat = -3
        let offset: CGFloat = inset * 2
        let group = CGRect(x: bounds.minX + inset,
                           y: bounds.minY + inset,
                           width: bounds.width - offset,
                           height: bounds.height - offset)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: group.minX + 0.27083 * group.width,
                                    y: group.minY + 0.54167 * group.height))
        bezierPath.addLine(to: CGPoint(x: group.minX + 0.41667 * group.width,
                                       y: group.minY + 0.68750 * group.height))
        bezierPath.addLine(to: CGPoint(x: group.minX + 0.75000 * group.width,
                                       y: group.minY + 0.35417 * group.height))
        bezierPath.lineCapStyle = CGLineCap.square
        return bezierPath
    }

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        setBoxLayouts()
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 18, height: 18)
    }

    // MARK: - Actions

    private func updateFillState() {
        outerBoxLayer.fillColor = self.isSelected ? UIColor.SS.Slate.base.cgColor : UIColor.clear.cgColor
        checkmarkLayer.strokeColor = UIColor.white.cgColor
    }

    private func setBoxLayouts() {
        outerBoxLayer.frame = bounds
        outerBoxLayer.lineWidth = outerBoxLineWidth
        outerBoxLayer.path = boxPath.cgPath

        checkmarkLayer.frame = bounds
        checkmarkLayer.lineWidth = outerBoxLineWidth
        checkmarkLayer.path = checkmarkPath.cgPath

        addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }

    @objc private func toggleSelected() {
        self.isSelected = !self.isSelected
    }

    // MARK: Setup

    private func setup() {
        outerBoxLayer.frame = bounds
        outerBoxLayer.lineWidth = 1
        outerBoxLayer.fillColor = UIColor.clear.cgColor
        outerBoxLayer.strokeColor = UIColor.SS.Slate.base.cgColor
        layer.addSublayer(outerBoxLayer)

        checkmarkLayer.frame = bounds
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(checkmarkLayer)

        updateFillState()
    }
}

#endif

