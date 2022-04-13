//
//  StepRowView.swift
//  
//
//  Created by Rob Visentin on 3/23/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class StepRowView: UIView {

    public enum LabelStyle {
        case bullet
        case text
        case none
    }

    public enum Item {
        case text(String, StringStyle = StepRowView.Constants.defaultTextStyle)
        case image(UIImage)
        case custom(UIView)
    }

    public enum Constants {
        public static let defaultLabelSpacing: CGFloat = 16
        public static let defaultItemSpacing: CGFloat = 8
        public static let defaultTextStyle = StringStyle.body1.byAdding(
            .xmlRules([.style("b", StringStyle.body1.weighted(.medium))])
        )
    }

    // MARK: - Properties

    public let labelStyle: LabelStyle

    public var stepIndex: Int {
        didSet {
            rebuildStepView()
        }
    }

    public var items: [Item] {
        didSet {
            rebuildItems()
        }
    }

    public var labelSpacing: CGFloat {
        get {
            contentStack.spacing
        }
        set {
            contentStack.spacing = newValue
        }
    }

    public var itemSpacing: CGFloat {
        get {
            itemStack.spacing
        }
        set {
            itemStack.spacing = newValue
        }
    }

    private let labelStack: UIStackView = {
        let itemStack = UIStackView()
        itemStack.axis = .horizontal
        itemStack.alignment = .top
        return itemStack
    }()

    private let itemStack: UIStackView = {
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.alignment = .leading
        itemStack.spacing = Constants.defaultItemSpacing
        return itemStack
    }()

    private lazy var contentStack: UIStackView = {
        let contentStack = UIStackView(arrangedSubviews: [labelStack, itemStack])
        contentStack.spacing = Constants.defaultLabelSpacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        return contentStack
    }()

    // MARK: - Lifecycle

    public init(labelStyle: LabelStyle, stepIndex: Int = 0, items: [Item] = []) {
        self.labelStyle = labelStyle
        self.stepIndex = stepIndex
        self.items = items

        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layoutMargins = .zero

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            contentStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])

        rebuildStepView()
        rebuildItems()
    }

    private func rebuildStepView() {
        labelStack.subviews.forEach { $0.removeFromSuperview() }
        labelStyle.makeLabel(index: stepIndex).map(labelStack.addArrangedSubview)
        labelStack.isHidden = labelStack.arrangedSubviews.isEmpty
    }

    private func rebuildItems() {
        itemStack.subviews.forEach { $0.removeFromSuperview() }
        items.map { $0.makeView() }.forEach(itemStack.addArrangedSubview)
    }

}

// MARK: - Styling

private extension StepRowView.LabelStyle {

    func makeLabel(index: Int) -> UILabel? {
        switch self {
        case .bullet:
            let label = UILabel(
                style: StringStyle.body2.colored(.white).aligned(.center),
                text: "\(index + 1)"
            )

            label.backgroundColor = UIColor.SS.Grey.basic
            label.layer.cornerRadius = 12
            label.layer.masksToBounds = true

            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 24),
                label.heightAnchor.constraint(equalToConstant: 24)
            ])

            return label
        case .text:
            let label = UILabel(
                style: StringStyle.label1.byAdding(
                    .baselineOffset(-1),
                    .color(UIColor.SS.Grey.medium),
                    .transform(.uppercase)
                ),
                text: String(format: "step.format".localized, index + 1)
            )

            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)

            return label
        case .none:
            return nil
        }
    }

}

private extension StepRowView.Item {

    func makeView() -> UIView {
        switch self {
        case .text(let text, let style):
            let label = UILabel(style: style, text: text)
            label.numberOfLines = 0
            return label
        case .image(let image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        case .custom(let view):
            return view
        }
    }

}

#endif
