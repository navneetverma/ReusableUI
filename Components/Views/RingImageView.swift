//
//  File.swift
//  
//
//  Created by Sindhu Majeti on 1/26/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Draws a ring around an image
final class RingImageView: UIView {

    // MARK: - Properties

    public var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    public var badgeText: String? {
        didSet {
            badge.styledText = badgeText
            badge.isHidden = badgeText == nil
        }
    }

    public override var contentMode: UIView.ContentMode {
        get {
            imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
        }
    }

    public var isDottedLine: Bool = false {
        didSet {
            ringShape.lineDashPattern = isDottedLine ? [3, 3] : nil
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var ringShape: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.SS.Blue.grey.cgColor
        shapeLayer.lineWidth = 1
        return shapeLayer
    }()

    private lazy var badge: UILabel = {
        let label = UILabel(style: StringStyle.title3.colored(UIColor.SS.Grey.cool).aligned(.center))
        label.backgroundColor = UIColor.SS.Blue.grey
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    init(image: UIImage? = nil) {
        super.init(frame: .zero)
        imageView.image = image
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        ringShape.path = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: 0.5 * min(bounds.width, bounds.height),
            startAngle: 0,
            endAngle: 2 * CGFloat.pi,
            clockwise: true
        ).cgPath
    }

    // MARK: - Actions

    private func setup() {
        badge.layer.cornerRadius = 12
        badge.layer.masksToBounds = true

        layer.addSublayer(ringShape)

        addSubview(imageView)
        addSubview(badge)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),

            badge.heightAnchor.constraint(equalToConstant: 24),
            badge.heightAnchor.constraint(equalTo: badge.widthAnchor),
            badge.topAnchor.constraint(equalTo: topAnchor),
            badge.trailingAnchor.constraint(equalTo: trailingAnchor),

            heightAnchor.constraint(equalTo: widthAnchor)
        ])

    }
}

#endif
