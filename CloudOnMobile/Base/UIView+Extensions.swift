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
}
