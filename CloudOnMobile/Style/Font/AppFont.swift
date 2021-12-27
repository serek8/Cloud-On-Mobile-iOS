//
//  AppFont.swift
//  PhoneDrive
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

protocol AppFont {
    /// Returns font for given type.
    /// - Parameters:
    ///   - type: Type of the font.
    func font(for type: FontStyle, size: CGFloat) -> UIFont
}

struct DefaultAppFont: AppFont {
    func font(for type: FontStyle, size: CGFloat) -> UIFont {
        switch type {
        case .regular:
            return UIFont(name: "Poppins-Regular", size: size)!
        }
    }
}
