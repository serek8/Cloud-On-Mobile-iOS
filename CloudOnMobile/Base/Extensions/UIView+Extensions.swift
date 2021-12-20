//
//  UIView+Extensions.swift
//  PhoneDrive
//
//  Created by Karol P on 09/12/2021.
//

import UIKit

public extension UIView {
    /// Add all subviews to a view in order defined in array.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(addSubview)
    }

    /// Removes all subviews from a view.
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Creates spacing view with defined height.
    /// - Parameters:
    ///   - height: height of the view.
    ///   - color: background color of the view.
    static func spacingView(
        height: CGFloat,
        color: UIColor? = AppStyle.current.appColor.color(for: .background)
    ) -> UIView {
        with(UIView()) {
            $0.backgroundColor = color
            $0.addConstraints { [
                $0.equalConstant(.height, height)
            ] }
        }
    }
}
