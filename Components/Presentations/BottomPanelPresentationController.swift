//
//  BottomPanelPresentationController.swift
//  
//
//  Created by Maxamilian Litteral on 6/3/20.
//

#if canImport(UIKit)
import UIKit

public class BottomPanelPresentationController: UIPresentationController {

    public enum Height {
        case `default`
        case custom(CGFloat)
        case automatic
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let backgroundAlpha: CGFloat = 0.4
        static let floatingWidth: CGFloat = 414
        static let defaultHeightRatio: CGFloat = 0.75
    }

    // MARK: - Properties

    var height: Height = .default

    private lazy var dimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: Constants.backgroundAlpha)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(gesture:)))
        view.addGestureRecognizer(tapGesture)

        return view
    }()

    var presentedViewSize = CGSize.zero
    weak var sourceController: UIViewController?

    var useFloatingAppearance: Bool {
        /// Use floating appearance when iPad is full width, otherwise use card layout
        return UIDevice.current.userInterfaceIdiom == .pad && (UIWindow.key?.bounds.width ?? 0) > 500
    }

    // MARK: - Lifecycle

    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerViewFrame = containerView?.frame else { return .zero }

        var frame = CGRect.zero

        if useFloatingAppearance {
            frame.size.width = Constants.floatingWidth // Match iPhone 11, (6/7/8)+, Xs, etc
        } else {
            frame.size.width = containerViewFrame.width
        }

        switch height {
        case .default:
            if presentedViewController.preferredContentSize.height > 0 {
                frame.size.height = presentedViewController.preferredContentSize.height
            } else if presentedViewController.view.frame.height > 0 {
                frame.size.height = presentedViewController.view.frame.height
            } else {
                frame.size.height = containerViewFrame.height * Constants.defaultHeightRatio
            }
        case .custom(let customHeight):
            frame.size.height = customHeight
        case .automatic:
            /// https://stackoverflow.com/questions/26391979/systemlayoutsizefittingsize-returning-incorrect-height-for-tableheaderview-und
            presentedViewController.view.setNeedsLayout()
            presentedViewController.view.layoutIfNeeded()
            frame.size.height = presentedViewController.view.systemLayoutSizeFitting(CGSize(
                width: frame.width,
                height: UIView.layoutFittingCompressedSize.height
            )).height
        }

        if useFloatingAppearance {
            frame.origin.x = containerViewFrame.width / 2 - frame.width / 2
            frame.origin.y = containerViewFrame.height / 2 - frame.height / 2
        } else {
            frame.origin.y = containerViewFrame.height - frame.height
        }

        return frame
    }

    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)

        if let presentedView = presentedView {
            presentedView.frame = frameOfPresentedViewInContainerView
        }
    }

    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimView.alpha = 0
        }, completion: { _ in
            self.dimView.removeFromSuperview()
        })
    }

    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        guard completed else { return }
        sourceController?.removeCardTransitionManager()
    }

    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        if !useFloatingAppearance {
            presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        presentedView?.layer.masksToBounds = true
        presentedView?.accessibilityViewIsModal = true
        presentedView?.layer.cornerRadius = Constants.cornerRadius

        dimView.alpha = 0
        containerView?.addSubview(dimView)

        containerView?.layoutIfNeeded()

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimView.alpha = 1
        })
    }

    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.frame = frameOfPresentedViewInContainerView
        dimView.frame = containerView?.bounds ?? .zero
    }

    public override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            self.presentedView?.layer.cornerRadius = Constants.cornerRadius
        }, completion: nil)
    }

    // MARK: - Actions

    @objc private func dimmingViewTapped(gesture: UITapGestureRecognizer) {
        guard gesture.state == .recognized else { return }
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}

public class BottomPanelTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var height: BottomPanelPresentationController.Height = .default

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = BottomPanelPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        presentationController.sourceController = source
        presentationController.height = height
        return presentationController
    }
}

extension UIViewController {
    private struct AssociatedKeys {
        static var cardTransitionManager = "BottomPanelTransitioningDelegate"
    }
    
    public var cardTransitionManager: UIViewControllerTransitioningDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.cardTransitionManager) as? UIViewControllerTransitioningDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.cardTransitionManager, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func removeCardTransitionManager() {
        cardTransitionManager = nil
    }


    /// Sets up the custom presentation for presenting a view from the bottom as a card
    /// - Parameters:
    ///   - height: The desired height of the popup
    ///   - fallbackPresentation: If the desired height of the panel is taller than the device, the fallback presentaiton will be used
    /// - Returns: Transition delegate if used
    @discardableResult
    public func setupTransitionForBottomPanel(height: BottomPanelPresentationController.Height = .default, fallbackPresentation: UIModalPresentationStyle = .fullScreen) -> BottomPanelTransitioningDelegate? {
        if case .custom(let customHeight) = height {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0

            if UIScreen.main.bounds.height < customHeight + topPadding + bottomPadding {
                modalPresentationStyle = fallbackPresentation
                cardTransitionManager = nil
                transitioningDelegate = nil
                return nil
            }
        }

        let transitionDelegate = BottomPanelTransitioningDelegate()
        transitionDelegate.height = height
        modalPresentationStyle = .custom
        cardTransitionManager = transitionDelegate
        transitioningDelegate = transitionDelegate
        modalPresentationCapturesStatusBarAppearance = true
        return transitionDelegate
    }

    @available(*, deprecated)
    @discardableResult
    public func setupTransitionForBottomPanel(height: CGFloat, fallbackPresentation: UIModalPresentationStyle = .fullScreen) -> BottomPanelTransitioningDelegate? {
        return setupTransitionForBottomPanel(height: .custom(height), fallbackPresentation: fallbackPresentation)
    }
}

#endif
