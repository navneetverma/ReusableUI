//
//  RadioButton.swift
//  
//
//  Created by Maxamilian Litteral on 1/22/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public final class RadioButton: UIButton {

    // MARK: - Properties

    @IBInspectable public var outerCircleLineWidth: CGFloat = 1 {
        didSet {
            setCircleLayouts()
        }
    }

    @IBInspectable public var innerCircleGap: CGFloat = 3 {
        didSet {
            setCircleLayouts()
        }
    }

    public override var isSelected: Bool {
        didSet {
            updateFillState()
        }
    }

    private let outerCircleLayer = CAShapeLayer()
    private let innerCircleLayer = CAShapeLayer()

    private var circleRadius: CGFloat {
        (min(bounds.width, bounds.height) - outerCircleLineWidth) / 2
    }

    private var circleFrame: CGRect {
        let width = bounds.width
        let height = bounds.height

        let radius = circleRadius
        let x: CGFloat
        let y: CGFloat

        if width > height {
            y = outerCircleLineWidth / 2
            x = (width / 2) - radius
        } else {
            x = outerCircleLineWidth / 2
            y = (height / 2) - radius
        }

        let diameter = 2 * radius
        return CGRect(x: x, y: y, width: diameter, height: diameter)
    }

    private var circlePath: UIBezierPath {
        UIBezierPath(roundedRect: circleFrame, cornerRadius: circleRadius)
    }

    private var fillCirclePath: UIBezierPath {
        let trueGap = innerCircleGap + (outerCircleLineWidth / 2)
        return UIBezierPath(roundedRect: circleFrame.insetBy(dx: trueGap, dy: trueGap), cornerRadius: circleRadius)
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
        setCircleLayouts()
    }

    // MARK: - Actions

    private func updateFillState() {
        innerCircleLayer.fillColor = isSelected ? UIColor.SS.Slate.base.cgColor : UIColor.clear.cgColor
    }

    private func setCircleLayouts() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.path = circlePath.cgPath

        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.path = fillCirclePath.cgPath

        addTarget(self, action: #selector(toggleSelected), for: .touchUpInside)
    }

    @objc private func toggleSelected() {
        isSelected = !isSelected
    }

    // MARK: Setup

    private func setup() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = 1
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = UIColor.SS.Slate.base.cgColor
        layer.addSublayer(outerCircleLayer)

        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = 1
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(innerCircleLayer)
        updateFillState()
    }
}

#endif
