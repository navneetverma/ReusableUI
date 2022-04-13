//
//  CyclingPillLabel.swift
//  
//
//  Created by Maxamilian Litteral on 3/22/21.
//

#if canImport(UIKit)
import UIKit
import BonMot

/// Pill shaped label that cycles between different values passed in
public class CyclingPillLabel: UIControl {

    // MARK: - Properties

    private enum Constants {
        static let preferredHeight: CGFloat = 36
        static let backgroundAlpha: CGFloat = 0.6
        static let defaultLabelStyle = StringStyle.label1.colored(UIColor.white).aligned(.center)
    }

    // MARK: Data

    public var values: [CustomStringConvertible] {
        didSet {
            currentValue = min(currentValue, values.endIndex - 1)
        }
    }

    public var currentValue: Int {
        didSet {
            if shouldCycleInfinitely && !values.isEmpty {
                currentValue = ((currentValue % values.count) + values.count) % values.count
            } else {
                currentValue = max(values.startIndex, min(currentValue, values.endIndex - 1))
            }

            updateLabel()

            if currentValue != oldValue {
                sendActions(for: .valueChanged)
            }
        }
    }

    public var currentTextValue: CustomStringConvertible? {
        if values.indices.contains(currentValue) {
            return values[currentValue]
        }
        return nil
    }

    /// If `true` the `currentValue` will reset at 0 after the last value, or will go to the last value if going backwards from 0.
    public var shouldCycleInfinitely = false

    public override var backgroundColor: UIColor? {
        get {
            backgroundView.backgroundColor
        }
        set {
            backgroundView.backgroundColor = newValue
        }
    }

    public var style: StringStyle? {
        get {
            valueLabel.bonMotStyle
        }
        set {
            valueLabel.bonMotStyle = newValue
        }
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(
            width: max(44, super.intrinsicContentSize.width),
            height: Constants.preferredHeight
        )
    }

    private let backgroundView: UIView = {
        let view = UIView()
        view.alpha = Constants.backgroundAlpha
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let valueLabel: UILabel = {
        let label = UILabel(style: Constants.defaultLabelStyle)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("Use init(currentValue:values:shouldCycleInfinitely:) instead")
    }

    public init(currentValue: Int = 0, values: [CustomStringConvertible] = [], shouldCycleInfinitely: Bool = false) {
        self.currentValue = currentValue
        self.values = values
        self.shouldCycleInfinitely = shouldCycleInfinitely
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    @objc public func cycleToNextValue() {
        currentValue += 1
    }

    @objc public func cycleToPreviousValue() {
        currentValue -= 1
    }

    public func set(values: [CustomStringConvertible], currentValue: Int) {
        self.values = values
        self.currentValue = currentValue
    }

    private func updateLabel() {
        if values.indices.contains(currentValue) {
            valueLabel.styledText = values[currentValue].description
        } else {
            valueLabel.styledText = nil
        }
    }

    // MARK: Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    private func setup() {
        backgroundColor = UIColor.SS.Blue.grey
        layoutMargins = UIEdgeInsets(xInset: 16, yInset: 8)

        addSubview(backgroundView)
        addSubview(valueLabel)

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            valueLabel.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
        ])

        updateLabel()
    }
}
#endif
