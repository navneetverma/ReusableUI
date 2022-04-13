//
//  AlertPresentationController.swift
//  
//
//  Created by Siddarth Gandhi on 7/2/20.
//

#if canImport(UIKit)

import UIKit

public class AlertPresentationController: UIPresentationController {

    // MARK: - Properties

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        view.addGestureRecognizer(recognizer)
        return view
    }()

    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else { return .zero }

        switch traitCollection.horizontalSizeClass {
        case .compact, .unspecified: // Inset from edges
            let horizontalInset: CGFloat = 20
            let width = bounds.width - horizontalInset * 2
            let height = width / 0.57
            let verticalInset = (bounds.height - height) / 2

            return CGRect(x: horizontalInset, y: verticalInset, width: width, height: height)
        case .regular: // Centered view with default width / height
            let width: CGFloat = 335 // Value from Sketch
            let height = width / 0.57
            let verticalInset = (bounds.height - height) / 2
            let horizontalInset = (bounds.width - width) / 2

            return CGRect(x: horizontalInset, y: verticalInset, width: width, height: height)
        @unknown default:
            fatalError("")
        }
    }

    // MARK: - Lifecycle

    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Actions

    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    public override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    public override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)

        presentedView?.layer.cornerRadius = 5
        presentedView?.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        })
    }

    public override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 0.0
        })
    }

    // MARK: Keyboard notifications

    @objc private func animateWithKeyboard(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardHeight = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else { return }

        let movingUp = notification.name == UIResponder.keyboardWillShowNotification

        UIView.animate(withDuration: duration) {
            self.presentedView?.frame = movingUp ? self.frameOfPresentedViewInContainerView.offsetBy(dx: 0, dy: -keyboardHeight.cgRectValue.height / 2) : self.frameOfPresentedViewInContainerView
        }
    }
}

#endif
