//
//  Tooltip.swift
//  
//
//  Created by Sindhu Majeti on 7/28/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class Tooltip: UIView {

    private let text: String
    private var triangleShapeLayer: CAShapeLayer?
    
    // MARK: - Lifecycle

    public required init?(coder: NSCoder) { fatalError("Use init(title:) instead") }

    public override init(frame: CGRect) { fatalError("Use init(title:) instead") }

    public required init(title: String) {
        self.text = title
        super.init(frame: .zero)
        setup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updatePosition()
    }

    // MARK: - Actions
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.SS.Blue.base
        layer.opacity = 0.9
        
        let titleLabel = UILabel()
        titleLabel.bonMotStyle = StringStyle.label1.byAdding(
            .color(UIColor.SS.Grey.cool),
            .lineBreakMode(.byWordWrapping)
        )
        titleLabel.styledText = text
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.numberOfLines = 0

        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])

        for (fromAttr, toAttr) in [
            NSLayoutConstraint.Attribute.top: NSLayoutConstraint.Attribute.topMargin,
            NSLayoutConstraint.Attribute.right: NSLayoutConstraint.Attribute.rightMargin,
            NSLayoutConstraint.Attribute.bottom: NSLayoutConstraint.Attribute.bottomMargin,
            NSLayoutConstraint.Attribute.left: NSLayoutConstraint.Attribute.leftMargin
        ] {
            addConstraint(NSLayoutConstraint(item: titleLabel, attribute: fromAttr, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: toAttr, multiplier: 1, constant: 0))
        }
        displayTooltip()
    }

    private func displayTooltip() {
        layoutMargins = UIEdgeInsets(top: 8, left: 13, bottom: 8, right: 13)
        layer.cornerRadius = 4
        triangleShapeLayer?.removeFromSuperlayer()
        triangleShapeLayer = createTriangleShapeLayer()
        layer.addSublayer(triangleShapeLayer ?? CAShapeLayer())
        setNeedsLayout()
    }

    private func createTriangleShapeLayer() -> CAShapeLayer {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: 12, y: 0))
        trianglePath.addLine(to: CGPoint(x: 6, y: 7))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        trianglePath.close()

        let triangleShapeLayer = CAShapeLayer()
        triangleShapeLayer.bounds = trianglePath.bounds
        triangleShapeLayer.path = trianglePath.cgPath
        triangleShapeLayer.fillColor = UIColor.SS.Blue.base.cgColor
        return triangleShapeLayer
    }

    private func updatePosition() {
        let triangleBounds = triangleShapeLayer?.bounds
        triangleShapeLayer?.anchorPoint = CGPoint(x: 0.5, y: 0)
        triangleShapeLayer?.position = CGPoint(x: bounds.width / 2, y: bounds.height - 0.25)
        triangleShapeLayer?.bounds = triangleBounds ?? CGRect()
    }

}

#endif
