//
//  OnboardingReminderCardNavigator.swift
//  
//
//  Created by Madeline Hulse on 5/18/20.
//

import Foundation
#if canImport(UIKit)
import UIKit

open class OnboardingReminderCardNavigator: NSObject {
    
    // MARK: - Properties

    public private(set) var parentViewController: UIViewController
    
    // MARK: - Lifecycle

    public init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension OnboardingReminderCardNavigator: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
#endif
