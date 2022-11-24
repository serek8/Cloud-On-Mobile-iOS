//
//  UIStackView+Extensions.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

extension UIStackView {
    /// Adds all arranged subviews in order defined in array
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach(addArrangedSubview)
    }
}
