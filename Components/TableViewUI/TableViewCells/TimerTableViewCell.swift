//
//  TimerTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 2/12/20.
//

#if canImport(UIKit)
import UIKit

final class TimerTableViewCell: TableViewCell {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var detailText: String? {
        didSet {
            detailLabel.styledText = detailText
        }
    }

    public var valueRange: ClosedRange<TimeInterval> {
        get {
            stepTimer.minValue...stepTimer.maxValue
        }
        set {
            stepTimer.minValue = newValue.lowerBound
            stepTimer.maxValue = newValue.upperBound
        }
    }

    public var stepValue: TimeInterval {
        get {
            stepTimer.stepValue
        }
        set {
            stepTimer.stepValue = newValue
        }
    }

    public var currentValue: TimeInterval {
        get {
            stepTimer.currentValue
        }
        set {
            stepTimer.currentValue = newValue
        }
    }

    public var valueDidChange: ((TimeInterval) -> Void)?

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var detailLabel: UILabel = {
        let label = UILabel(style: .body4)
        label.numberOfLines = 0
        return label
    }()

    private lazy var stepTimer: StepTimerControl = {
        let timer = StepTimerControl(min: 0, max: 0, step: 1)
        timer.durationDidChange = { [weak self] in self?.valueDidChange?($0) }
        timer.translatesAutoresizingMaskIntoConstraints = false
        return timer
    }()

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        detailText = nil
        valueRange = 0...0
        stepValue = 1
        currentValue = 0
        valueDidChange = nil
    }

    // MARK: Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 16)

        let timerContainerView = UIView()
        timerContainerView.addSubview(stepTimer)

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .leading
        labelStack.spacing = 4

        let stackView = UIStackView(arrangedSubviews: [labelStack, timerContainerView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),

            stepTimer.topAnchor.constraint(equalTo: timerContainerView.topAnchor),
            stepTimer.bottomAnchor.constraint(equalTo: timerContainerView.bottomAnchor),
            stepTimer.centerXAnchor.constraint(equalTo: timerContainerView.centerXAnchor)
        ])
    }
}
#endif
