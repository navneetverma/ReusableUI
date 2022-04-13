//
//  SegmentedControl.swift
//
//
//  Created by Vishwanath Deshmukh on 9/4/20.
//

import Foundation

#if canImport(UIKit)
import BonMot
import UIKit

/// Custom Segment Control to match SimpliSafe UI standards
public class SegmentedControl: UIControl {

    private enum Constants {
        static let defaultHeight: CGFloat = 26
        static let fullHeight: CGFloat = 52
        static let borderWidth: CGFloat = 2
    }

    // MARK: - Properties

    public var selectedSegmentIndex: Int {
        get {
            return _selectedSegmentIndex
        }
        set {
            _selectedSegmentIndex = newValue
            guard buttons.indices.contains(newValue) else { return }
            set(selectedButton: buttons[newValue], sendActions: false)
        }
    }

    private lazy var selectorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let titles: [String]
    private let images: [UIImage]
    private let segmentHeight: CGFloat

    private var buttons = [UIButton]()
    private weak var selectedIndexCenterXConstraint: NSLayoutConstraint?

    private var _selectedSegmentIndex: Int = 0

    // MARK: - Lifecycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(titles: [String]) {
        self.titles = titles
        self.images = []
        self.segmentHeight = Constants.defaultHeight

        super.init(frame: .zero)

        setup()
    }

    public required init(titles: [String], images: [UIImage]) {
        self.titles = titles
        self.images = images
        self.segmentHeight = Constants.fullHeight

        super.init(frame: .zero)

        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.SS.Grey.basic
        layer.cornerRadius = 0.5 * segmentHeight

        selectorView.backgroundColor = UIColor.SS.Slate.base
        selectorView.layer.cornerRadius = 0.5 * (segmentHeight - 2 * Constants.borderWidth)

        createButtons()
        buildLayout()

        selectedSegmentIndex = 0
    }

    private func createButtons() {
        buttons = titles.enumerated().map { index, title in
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(segmentAction), for: .primaryActionTriggered)

            let image = images.indices.contains(index) ? images[index] : nil
            let titleComponents = ([image, title] as [Composable?]).compactMap { $0 }

            var style = StringStyle.body4.aligned(.center)
            style.minimumLineHeight = (image != nil) ? 18 : nil

            var selectedStyle = StringStyle.body3.aligned(.center).colored(.white)
            selectedStyle.minimumLineHeight = style.minimumLineHeight

            let title = NSAttributedString.composed(of: titleComponents, baseStyle: style, separator: Special.nextLine)
            let selectedTitle = NSAttributedString.composed(of: titleComponents, baseStyle: selectedStyle, separator: Special.nextLine)

            button.setAttributedTitle(title, for: .normal)
            button.setAttributedTitle(title, for: .highlighted)
            button.setAttributedTitle(selectedTitle, for: .selected)
            button.setAttributedTitle(selectedTitle, for: [.selected, .highlighted])
            button.titleLabel?.numberOfLines = 0

            return button
        }
    }

    private func buildLayout() {
        addSubview(selectorView)

        buttons.forEach(segmentStackView.addArrangedSubview)
        addSubview(segmentStackView)

        let selectorWidth = buttons.isEmpty ? 1 : 1 / CGFloat(buttons.count)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: segmentHeight),
            segmentStackView.topAnchor.constraint(equalTo: topAnchor),
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            segmentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: selectorWidth, constant: -2 * Constants.borderWidth),
            selectorView.heightAnchor.constraint(equalToConstant: segmentHeight - 2 * Constants.borderWidth)
        ])
    }

    // MARK: - Actions

    @objc private func segmentAction(sender: UIButton) {
        set(selectedButton: sender, sendActions: true)
    }

    private func set(selectedButton: UIButton, sendActions: Bool) {
        for (index, button) in buttons.enumerated() {
            if button == selectedButton {
                _selectedSegmentIndex = index
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }

        selectedIndexCenterXConstraint?.isActive = false
        selectedIndexCenterXConstraint = selectorView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        selectedIndexCenterXConstraint?.isActive = true

        if window != nil {
            UIView.animate(withDuration: 0.2, animations: layoutIfNeeded)
        }

        if sendActions {
            self.sendActions(for: .valueChanged)
        }
    }
}

#endif
