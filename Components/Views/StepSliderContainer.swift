//
//  StepSliderContainer.swift
//  
//
//  Created by Maxamilian Litteral on 2/11/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Contains a StepSlider and labels aligned to the steps
public final class StepSliderContainer: UIView, StepSliderDelegate {

    private enum Constants {
        static let labelStyle = StringStyle.message1.colored(UIColor.SS.Grey.medium)
        static let selectedLabelStyle = StringStyle.message2.colored(UIColor.SS.Slate.base)
    }

    // MARK: - Properties

    let options: [SliderOptionConvertible]

    weak var delegate: StepSliderDelegate?

    private let slider: StepSlider
    private let labels: [UILabel]
    private let labelsView = UIView()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelsView, slider])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(value: @escaping SliderValue, options: [SliderOptionConvertible]) {
        self.slider = StepSlider(value: value, options: options)
        self.options = options
        self.labels = options.enumerated().map { (index, option) -> UILabel in
            UILabel(
                style: index == value() ? Constants.selectedLabelStyle : Constants.labelStyle,
                text: option.title
            )
        }
        super.init(frame: .zero)
        self.slider.delegate = self
        setup()
    }

    // MARK: - Actions

    // MARK: StepSliderDelegate

    func slider(didSelect index: Int) {
        labels.enumerated().forEach { (_index, label) in
            if _index == index {
                label.bonMotStyle = Constants.selectedLabelStyle
            } else {
                label.bonMotStyle = Constants.labelStyle
            }
        }

        delegate?.slider(didSelect: index)
    }

    // MARK: Setup

    private func setup() {
        labels.forEach { labelsView.addSubview($0) }
        addSubview(stackView)

        let labelConstraints = labels.enumerated().map { (i, label) -> [NSLayoutConstraint] in
            let pct = CGFloat(i) / CGFloat(labels.count - 1)

            let centerXConstraint = pct > 0 ? NSLayoutConstraint(
                item: label,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: slider,
                attribute: .trailing,
                multiplier: pct,
                constant: 0
            ) : label.centerXAnchor.constraint(equalTo: slider.leadingAnchor)
            centerXConstraint.priority = .defaultHigh

            return [
                label.leadingAnchor.constraint(greaterThanOrEqualTo: slider.leadingAnchor),
                centerXConstraint,
                label.trailingAnchor.constraint(lessThanOrEqualTo: slider.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: slider.topAnchor)
            ]
        }.flatMap { $0 }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ] + labelConstraints)
    }
}
#endif
