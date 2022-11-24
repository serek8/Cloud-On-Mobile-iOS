//
//  UILabel+Extensions.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

extension UILabel {
    /// Adds spacing between characters.
    /// - Parameters:
    ///   - value: value of spacing.
    func addCharactersSpacing(value: CGFloat) {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
}
