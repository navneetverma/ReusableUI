//
//  GradientView.swift
//  
//
//  Created by Rob Visentin on 3/31/21.
//

#if canImport(UIKit)
import UIKit

open class GradientView: UIView {

    public override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradient = Gradient() {
        didSet {
            (layer as? CAGradientLayer).map(gradient.apply)
        }
    }

    convenience init(gradient: Gradient) {
        self.init(frame: .zero)
        self.gradient = gradient
        (layer as? CAGradientLayer).map(gradient.apply)
    }

}

public struct Gradient {

    public typealias KeyPoint = (color: UIColor, location: CGFloat)

    public var start = CGPoint(x: 0.5, y: 0)
    public var end = CGPoint(x: 0.5, y: 1)

    public var keyPoints: [KeyPoint]? {
        didSet {
            keyPoints = keyPoints?.sorted(by: { $0.location < $1.location })
        }
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, colors: [UIColor]? = nil) {
        if axis == .horizontal {
            start = CGPoint(x: start.y, y: start.x)
            end = CGPoint(x: end.y, y: end.x)
        }
        set(colors: colors)
    }

    public init(axis: NSLayoutConstraint.Axis = .vertical, keyPoints: [KeyPoint]) {
        if axis == .horizontal {
            start = CGPoint(x: start.y, y: start.x)
            end = CGPoint(x: end.y, y: end.x)
        }
        self.keyPoints = keyPoints
    }

    public mutating func set(colors: [UIColor]?) {
        guard let colors = colors, !colors.isEmpty else {
            keyPoints = nil
            return
        }

        guard colors.count > 1 else {
            keyPoints = [(color: colors[0], location: 0)]
            return
        }

        keyPoints = colors.enumerated().map { idx, color in
            return (color: color, location: CGFloat(idx) / CGFloat(colors.count - 1))
        }
    }

    public func apply(to layer: CAGradientLayer) {
        layer.startPoint = start
        layer.endPoint = end
        layer.colors = keyPoints?.map { $0.color.cgColor }
        layer.locations = keyPoints?.map { NSNumber(value: Double($0.location)) }
    }

}
#endif
