//
//  ScrollingStackView.swift
//  
//
//  Created by Rob Visentin on 1/21/21.
//

#if canImport(UIKit)
import UIKit

open class ScrollingStackView: UIScrollView {

    public let content: UIStackView

    public init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment = .fill, spacing: CGFloat = 0, arrangedSubviews: [UIView] = []) {
        content = UIStackView(arrangedSubviews: arrangedSubviews)

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        content.translatesAutoresizingMaskIntoConstraints = false
        content.axis = axis
        content.alignment = alignment
        content.spacing = spacing

        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        let contentWrapper = UIView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentWrapper)
        contentWrapper.addSubview(content)

        var constraints = [NSLayoutConstraint]()

        constraints.append(contentsOf: [
            contentWrapper.topAnchor.constraint(equalTo: topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        switch axis {
        case .horizontal:
            alwaysBounceHorizontal = true
            constraints.append(contentsOf: [
                contentWrapper.heightAnchor.constraint(equalTo: heightAnchor),
                contentWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentWrapper.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
            ])

        case .vertical:
            alwaysBounceVertical = true
            constraints.append(contentsOf: [
                contentWrapper.widthAnchor.constraint(equalTo: widthAnchor),
                contentWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentWrapper.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
            ])
        @unknown default:
            fatalError("Unknown axis \(axis)")
        }

        constraints.append(contentsOf: [
            content.topAnchor.constraint(equalTo: contentWrapper.topAnchor),
            content.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor),
            content.bottomAnchor.constraint(lessThanOrEqualTo: contentWrapper.bottomAnchor),
            content.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor)
        ])

        NSLayoutConstraint.activate(constraints)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
#endif
