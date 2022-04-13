//
//  StepTimerControl.swift
//  
//
//  Created by Maxamilian Litteral on 2/12/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

public class StepTimerControl: UIControl {

    // MARK: - Properties

    public var minValue: TimeInterval
    public var maxValue: TimeInterval
    public var stepValue: TimeInterval
    public var currentValue: TimeInterval {
        didSet {
            guard currentValue >= minValue && currentValue <= maxValue else {
                self.currentValue = oldValue
                return
            }

            if currentValue == minValue {
                minusButton.isEnabled = false
            } else {
                minusButton.isEnabled = true
            }

            if currentValue == maxValue {
                plusButton.isEnabled = false
            } else {
                plusButton.isEnabled = true
            }

            minutesLabel.styledText = String(Int((currentValue / 60).truncatingRemainder(dividingBy: 60)))
            secondsLabel.styledText = String(Int(currentValue.truncatingRemainder(dividingBy: 60)))
        }
    }
    public var durationDidChange: ((TimeInterval) -> Void)?

    private let minutesLabel = UILabel(style: .headline1, text: "0")
    private let secondsLabel = UILabel(style: .headline1, text: "0")

    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Plus", in: .module, compatibleWith: nil), for: .normal)
        button.setImage(UIImage(named: "PlusGrey", in: .module, compatibleWith: nil), for: .disabled)
        button.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Minus", in: .module, compatibleWith: nil), for: .normal)
        button.setImage(UIImage(named: "MinusGrey", in: .module, compatibleWith: nil), for: .disabled)
        button.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) { fatalError("Use init(min:max:step:currentValue:) instead") }

    public init(min: TimeInterval, max: TimeInterval, step: TimeInterval, currentValue: TimeInterval = 0) {
        self.minValue = min
        self.maxValue = max
        self.stepValue = step
        self.currentValue = currentValue
        super.init(frame: .zero)
        setup()
    }

    // MARK: - Actions

    @objc private func plusButtonPressed() {
        if currentValue + stepValue < maxValue {
            currentValue = currentValue + stepValue - currentValue.truncatingRemainder(dividingBy: stepValue)
        } else {
            currentValue = maxValue
        }

        sendActions(for: .valueChanged)
        durationDidChange?(currentValue)
    }

    @objc private func minusButtonPressed() {
        if currentValue - stepValue > minValue {
            currentValue = currentValue - stepValue + currentValue.truncatingRemainder(dividingBy: stepValue)
        } else {
            currentValue = minValue
        }

        sendActions(for: .valueChanged)
        durationDidChange?(currentValue)
    }

    // MARK: Setup

    private func setup() {
        let minCaption = UILabel(style: .body3, text: "timer.minutes".localized)
        let secCaption = UILabel(style: .body3, text: "timer.seconds".localized)

        let stackView = UIStackView(arrangedSubviews: [
            minusButton,
            minutesLabel,
            minCaption,
            secondsLabel,
            secCaption,
            plusButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.setCustomSpacing(24, after: minusButton)
        stackView.setCustomSpacing(8, after: minutesLabel)
        stackView.setCustomSpacing(16, after: minCaption)
        stackView.setCustomSpacing(8, after: secondsLabel)
        stackView.setCustomSpacing(24, after: secCaption)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

#endif
