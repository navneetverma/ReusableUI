//
//  OnboardingReminderCard.swift
//  
//
//  Created by Madeline Hulse on 5/18/20.
//

import Foundation
#if canImport(UIKit)
import UIKit
import BonMot

public class OnboardingReminderCard: DashboardCardBase, OnboardingReminderCardViewModelDelegate {

    // MARK: - Properties

    private let viewModel: OnboardingReminderCardViewModel
    
    public var titleLabel: UILabel = {
        let label = UILabel(style: StringStyle.title2.byAdding(
            .color(UIColor.SS.Grey.dark)
        ))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    public var subtitleLabel: UILabel = {
        let label = UILabel(style: StringStyle.body4.byAdding(
            .color(UIColor.SS.Grey.dark)
        ))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()

    public var leadingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public var primaryButton: AmbientButton
    public var secondaryButton: AmbientButton
    public var dismissButton: AmbientButton

    public var secondarySubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 14)
        label.textColor = UIColor.SS.Grey.medium
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Lifecycle

    required init?(coder: NSCoder) { fatalError("Use init(viewModel:) instead") }

    override init(frame: CGRect) { fatalError("Use init(viewModel:) instead") }

    public init(viewModel: OnboardingReminderCardViewModel) {
        self.viewModel = viewModel
        primaryButton = AmbientButton(title: viewModel.primaryButtonText)
        dismissButton = AmbientButton(title: viewModel.lastCallButtonText)
        secondaryButton = AmbientButton(style: .dismiss, title: viewModel.secondaryButtonText)
        super.init(frame: .zero)
        viewModel.delegate = self
        referralStateDidChange(viewModel.viewState)
    }
    
    // MARK: - Delegate

    func referralStateDidChange(_ state: OnboardingReminderCardViewModel.ViewState) {
        primaryButton.title = viewModel.primaryButtonText
        dismissButton.title = viewModel.lastCallButtonText
        secondaryButton.title = viewModel.secondaryButtonText
        setup(state)
        subviews.forEach({ $0.updateConstraints() })
    }
    
    // MARK: - Setup

    private func setup(_ state: OnboardingReminderCardViewModel.ViewState) {
        subviews.forEach({ $0.removeFromSuperview() })

        heightConstraint?.isActive = false
        translatesAutoresizingMaskIntoConstraints = false
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.addTarget(viewModel, action: #selector(viewModel.tappedAction), for: .touchUpInside)
        primaryButton.titleLabel?.leadingAnchor.constraint(equalTo: primaryButton.leadingAnchor).isActive = true
        primaryButton.titleLabel?.trailingAnchor.constraint(equalTo: primaryButton.trailingAnchor).isActive = true
        primaryButton.titleLabel?.topAnchor.constraint(equalTo: primaryButton.topAnchor).isActive = true
        primaryButton.titleLabel?.bottomAnchor.constraint(equalTo: primaryButton.bottomAnchor).isActive = true
        
        switch state {
        case .lastCall:
            addSubview(secondarySubtitle)
            secondarySubtitle.styledText = viewModel.lastCallBody
            
            addSubview(dismissButton)
            dismissButton.addTarget(viewModel, action: #selector(viewModel.finish), for: .touchUpInside)
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            dismissButton.titleLabel?.leadingAnchor.constraint(equalTo: dismissButton.leadingAnchor).isActive = true
            dismissButton.titleLabel?.trailingAnchor.constraint(equalTo: dismissButton.trailingAnchor).isActive = true
            dismissButton.titleLabel?.topAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true
            dismissButton.titleLabel?.bottomAnchor.constraint(equalTo: dismissButton.bottomAnchor).isActive = true
            NSLayoutConstraint.activate([
                secondarySubtitle.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                secondarySubtitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
                secondarySubtitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
                dismissButton.topAnchor.constraint(equalTo: secondarySubtitle.bottomAnchor),
                dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
                dismissButton.leadingAnchor.constraint(equalTo: secondarySubtitle.leadingAnchor)])

        case .titleOnly:
            addSubview(titleLabel)
            addSubview(primaryButton)
            titleLabel.styledText = viewModel.title
            titleLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 15)
            
            setupImageView()
            setupSecondaryButton()

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
                primaryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                primaryButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)])

        case .titleAndBody:
            addSubview(titleLabel)
            addSubview(subtitleLabel)
            addSubview(primaryButton)
            titleLabel.styledText = viewModel.title
            subtitleLabel.styledText = viewModel.subtitle

            setupImageView()
            setupSecondaryButton()

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                primaryButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
                primaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
                primaryButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)])
        case .finished:
            self.removeFromSuperview()
        }
        heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 90)
        widthAnchor.constraint(equalToConstant: 325).isActive = true
        heightConstraint?.isActive = true
    }
    
    private func setupImageView() {
        leadingImageView.image = viewModel.leadingImage
        if self.leadingImageView.image != nil {
            addSubview(leadingImageView)
            NSLayoutConstraint.activate([
                leadingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
                leadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                leadingImageView.widthAnchor.constraint(equalToConstant: 28),
                leadingImageView.heightAnchor.constraint(equalToConstant: 28),
                titleLabel.leadingAnchor.constraint(equalTo: leadingImageView.trailingAnchor, constant: 20)])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25)])
        }
    }
    
    private func setupSecondaryButton() {
        if viewModel.secondaryButtonText != nil {
            if viewModel.lastCallBody != nil {
                secondaryButton.addTarget(viewModel, action: #selector(viewModel.displayLastCall), for: .touchUpInside)
            } else {
                secondaryButton.addTarget(viewModel, action: #selector(viewModel.finish), for: .touchUpInside)
            }
            addSubview(secondaryButton)
            secondaryButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                secondaryButton.topAnchor.constraint(equalTo: primaryButton.topAnchor),
                secondaryButton.leadingAnchor.constraint(equalTo: primaryButton.trailingAnchor, constant: 25)
            ])
            secondaryButton.titleLabel?.leadingAnchor.constraint(equalTo: secondaryButton.leadingAnchor).isActive = true
            secondaryButton.titleLabel?.trailingAnchor.constraint(equalTo: secondaryButton.trailingAnchor).isActive = true
            secondaryButton.titleLabel?.topAnchor.constraint(equalTo: secondaryButton.topAnchor).isActive = true
            secondaryButton.titleLabel?.bottomAnchor.constraint(equalTo: secondaryButton.bottomAnchor).isActive = true
        }
    }

}
#endif
