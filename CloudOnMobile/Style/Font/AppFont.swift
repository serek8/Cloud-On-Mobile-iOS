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
    func font(for type: FontStyle) -> UIFont
}

final class DefaultAppFont: AppFont {
    func font(for type: FontStyle) -> UIFont {
        switch type {
        case .body16Regular:
            return UIFont(name: "Poppins-Regular", size: 16)!
        }
    }
}
