//
//  OnboardingReminderCardViewModel.swift
//  
//
//  Created by Madeline Hulse on 5/18/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

protocol OnboardingReminderCardViewModelDelegate: AnyObject {
    func referralStateDidChange(_ state: OnboardingReminderCardViewModel.ViewState)
}

open class OnboardingReminderCardViewModel {
        
    // MARK: - Properties
    
    public enum ViewState: Int {
        case lastCall
        case titleOnly
        case titleAndBody
        case finished
    }
    
    private(set) var viewState: ViewState {
        didSet {
            viewStateUpdated(viewState)
        }
    }
    
    let navigator: OnboardingReminderCardNavigator
    weak var delegate: OnboardingReminderCardViewModelDelegate?
    
    public var title: String
    public var subtitle: String?
    public var leadingImage: UIImage?
    public var primaryButtonText: String
    public var primaryButtonAction: Action?
    public var secondaryButtonText: String?
    public var lastCallBody: String?
    public var lastCallButtonText: String?
    
    // MARK: - Lifecycle

    public init(navigator: OnboardingReminderCardNavigator, title: String, subtitle: String? = nil, leadingImage: UIImage? = nil, primaryButtonText: String, primaryButtonAction: Action?, secondaryButtonText: String? = nil, lastCallBody: String? = nil, lastCallButtonText: String? = nil) {
        self.navigator = navigator
        self.title = title
        self.subtitle = subtitle
        self.leadingImage = leadingImage
        self.primaryButtonText = primaryButtonText
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonText = secondaryButtonText
        self.lastCallBody = lastCallBody
        self.lastCallButtonText = lastCallButtonText
        if subtitle == nil {
            viewState = .titleOnly
        } else {
            viewState = .titleAndBody
        }
    }

    // MARK: - Actions

    @objc func tappedAction() {
        primaryButtonAction?()
    }

    @objc func displayLastCall() {
        viewState = .lastCall
        delegate?.referralStateDidChange(viewState)
    }
    
    @objc func finish() {
        viewState = .finished
        delegate?.referralStateDidChange(viewState)
    }
    
    public func display() {
        if viewState != .lastCall && viewState != .finished {
            if subtitle == nil {
                viewState = .titleOnly
            } else {
                viewState = .titleAndBody
            }
        }
        delegate?.referralStateDidChange(viewState)
    }

    open func viewStateUpdated(_ state: ViewState) {

    }
    
}
#endif
