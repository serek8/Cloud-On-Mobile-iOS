//
//  AutoKeyboard.swift
//
//
//  Created by Karol P on 21/10/2021.
//
// Based on https://github.com/PatrykKaczmarek/KeyboardLayoutGuide
//

import UIKit

protocol AutoKeyboard: NSObject {
    /// Flag indicating whether top keyboard layout guide should be tracked.
    /// It is recommended to set this flag in view controller's init method
    /// cause keyboard may appear before the view controller's view is fully loaded.
    ///
    /// Setting this property to `true` automatically registers view controller for keyboard notifications.
    /// Setting this property to `false` automatically removes view controller from keyboard notifications.
    ///
    /// Example:
    /// Few view controllers have been initialized at once but only one of them has been displayed.
    /// It means that only this one which is visible, loaded its view.
    /// Other view controllers will load their views (technically invoke viewDidLoad() method)
    /// shortly before they become visible.
    ///
    /// - SeeAlso: View.keyboardHeightConstraint
    /// - SeeAlso: View.KeyboardLayoutGuide
    /// - SeeAlso: UIViewController.isViewLoaded
    ///
    /// - Warning: Switching to emoji keyboard by pressing the language selector button (the globe) works fine.
    ///            Nevertheless when changing keyboard type by long pressing the language selector button,
    ///            no UIKeyboardWillChangeFrame notification is sent what causes layout guide to not be adjusted properly.
    ///            It looks as a bug on iOS 11, since even the apple messages and facebook messenger apps don't handle this right.
    var automaticallyAdjustKeyboardLayoutGuide: Bool { get set }

    /// Closure triggered when keyboard is going to appear.
    var onKeyboardWillAppear: ((Notification) -> Void)? { get set }

    /// Closure triggered when keyboard is going to disappear.
    var onKeyboardWillDisappear: ((Notification) -> Void)? { get set }

    /// Bottom Constraint used to adjust view to.
    var bottomConstraint: NSLayoutConstraint? { get }

    /// Container view.
    var containerView: UIView { get }

    /// Starts observing keyboard events notifications.
    func startObservingKeyboardNotifications()

    /// Stops observing keyboard events notifications.
    func stopObservingKeyboardNotifications()
}

extension AutoKeyboard {
    func startObservingKeyboardNotifications() {
        keyboardNotifications.forEach(registerForNotification)
    }

    func stopObservingKeyboardNotifications() {
        keyboardNotifications.forEach { NotificationCenter.default.removeObserver(self, name: $0, object: nil) }
    }
}

// MARK: - Private

private extension AutoKeyboard {
    /// An array of notification names used by self.
    var keyboardNotifications: [Notification.Name] {
        [
            UIResponder.keyboardWillHideNotification,
            UIResponder.keyboardWillShowNotification,
            UIResponder.keyboardWillChangeFrameNotification
        ]
    }

    func registerForNotification(name: Notification.Name) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: handleNotification(name: name))
    }

    func handleNotification(name: Notification.Name) -> (Notification) -> Void {
        { [weak self] notification in
            guard
                let self = self, self.automaticallyAdjustKeyboardLayoutGuide,
                var offset = notification.keyboardRect?.height
            else {
                return
            }

            switch name {
            case UIResponder.keyboardWillHideNotification:
                offset = 0
                self.onKeyboardWillDisappear?(notification)
            case UIResponder.keyboardWillShowNotification:
                self.onKeyboardWillAppear?(notification)
            default:
                break
            }

            let animationDuration = notification.keyboardAnimationDuration ?? 0.25
            self.bottomConstraint?.constant = -offset
            UIView.animate(withDuration: animationDuration) {
                self.containerView.superview?.layoutIfNeeded()
            }
        }
    }
}

// MARK: - Notification

private extension Notification {
    /// Defines the duration of keyboard animation.
    /// Nil if notification doesn't contain such info.
    var keyboardAnimationDuration: TimeInterval? {
        (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }

    /// Defines the rectangle of keyboard.
    /// Nil if notification doesn't contain such info.
    var keyboardRect: CGRect? {
        userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    }
}
