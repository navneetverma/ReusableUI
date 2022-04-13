//
//  File.swift
//  
//
//  Created by Maxamilian Litteral on 6/16/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public extension UIView {

    static func flexibleSpace() -> UIView {
        let spacer = UIStackView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.isUserInteractionEnabled = false
        spacer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        spacer.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)

        let widthConstraint = spacer.widthAnchor.constraint(equalToConstant: UIView.layoutFittingExpandedSize.width)
        widthConstraint.priority = UILayoutPriority(1)
        widthConstraint.isActive = true

        let heightConstraint = spacer.heightAnchor.constraint(equalToConstant: UIView.layoutFittingExpandedSize.height)
        heightConstraint.priority = UILayoutPriority(1)
        heightConstraint.isActive = true

        return spacer
    }

    func presentToast(title: String, icon: UIImage? = nil, duration: TimeInterval = 2) {
        let toast = Toast(title: title, icon: icon, duration: duration)
        toast.alpha = 0
        toast.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toast)

        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            toast.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        UIView.animate(withDuration: 0.5, animations: {
            toast.alpha = 1.0
        }, completion: { _ in
            UIAccessibility.post(notification: .announcement, argument: toast)
            let timer = Timer(timeInterval: duration, target: self, selector: #selector(UIView.viewTimerDidFinish(_:)), userInfo: toast, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        })
    }

    private func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    @objc
    private func viewTimerDidFinish(_ timer: Timer) {
        guard let view = timer.userInfo as? UIView else { return }
        view.hide()
    }
    
    func presentTooltip(title: String, button: UIButton) {
        let toolTip = Tooltip(title: title)
        toolTip.alpha = 0
        self.addSubview(toolTip)
        NSLayoutConstraint.activate([
            toolTip.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            toolTip.bottomAnchor.constraint(equalTo: button.topAnchor)
        ])
        UIView.animate(withDuration: 0.5, animations: {
            toolTip.alpha = 1
        }, completion: { _ in
            let timer = Timer(timeInterval: 2, target: self, selector: #selector(UIView.viewTimerDidFinish(_:)), userInfo: toolTip, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        })
    }
}

#endif
