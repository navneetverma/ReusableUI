//
//  ActivityOverlay.swift
//  
//
//  Created by Rob Visentin on 4/7/21.
//

#if canImport(UIKit)
import BonMot
import UIKit

public final class ActivityOverlay: UIView {

    private enum Constants {
        static let backgroundAlpha: CGFloat = 0.6
        static let defaultInterval: TimeInterval = 5
        static let spacing: CGFloat = 16
    }

    // MARK: - Properties

    public var style: UIActivityIndicatorView.Style {
        get {
            activityIndicator.style
        }
        set {
            activityIndicator.style = newValue
        }
    }

    public var messages: [String] {
        didSet {
            textLabel.values = messages
            textLabel.isHidden = messages.isEmpty
            reset()
        }
    }

    public var messageInterval: TimeInterval = Constants.defaultInterval {
        didSet {
            setupTimer()
        }
    }

    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    private lazy var textLabel: CyclingPillLabel = {
        let textLabel = CyclingPillLabel(values: messages, shouldCycleInfinitely: false)
        textLabel.backgroundColor = UIColor.SS.Slate.base
        textLabel.style = StringStyle.title2.colored(.white)
        return textLabel
    }()

    private var timer: Timer? {
        didSet {
            oldValue?.invalidate()
            timer.map { RunLoop.main.add($0, forMode: .common) }
        }
    }

    // MARK: - Lifecycle

    public init(messages: [String] = []) {
        self.messages = messages
        super.init(frame: .zero)
        setup()
    }

    public convenience init(messages: [String] = [], messageInterval: TimeInterval) {
        self.init(messages: messages)
        self.messageInterval = messageInterval
        setupTimer()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if window != nil {
            activityIndicator.startAnimating()
        }

        setupTimer()
    }

    deinit {
        timer = nil
    }

    // MARK: - Action

    public func reset() {
        textLabel.currentValue = 0
        setupTimer()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(Constants.backgroundAlpha)

        let contentStack = UIStackView(arrangedSubviews: [activityIndicator, textLabel])
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = Constants.spacing
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        setupTimer()
    }

    private func setupTimer() {
        if messageInterval > 0 && window != nil {
            timer = Timer(timeInterval: messageInterval, repeats: true, block: { [weak self] _ in
                self?.textLabel.cycleToNextValue()
            })
        } else {
            timer = nil
        }
    }

}

#endif
