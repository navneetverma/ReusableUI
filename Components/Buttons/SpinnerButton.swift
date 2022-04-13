//
//  SpinnerButton.swift
//  
//
//  Created by Maxamilian Litteral on 3/3/20.
//

#if canImport(UIKit)
import UIKit

public class SpinnerButton: CTAButton {

    // MARK: - Properties

    private let spinner = UIActivityIndicatorView(style: .white)

    var isAnimating: Bool {
        spinner.isAnimating
    }

    // MARK: - Lifecycle

    public init(priority: CTAButton.Priority = .primary, style: CTAButton.Style = .default, title: String? = nil) {
        super.init(priority: priority, style: style, title: title)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Actions

    public func startAnimating() {
        guard !isAnimating else { return }
        isUserInteractionEnabled = false
        titleLabel?.alpha = 0
        spinner.startAnimating()
    }

    public func stopAnimating() {
        guard isAnimating else { return }
        isUserInteractionEnabled = true
        titleLabel?.alpha = 1
        spinner.stopAnimating()
    }

    // MARK: Setup

    private func setup() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

#endif
