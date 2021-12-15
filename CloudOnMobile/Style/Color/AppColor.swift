//
//  AppColor.swift
//  PhoneDrive
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

protocol AppColor {
    /// Returns UIColor for given type.
    /// - Parameters:
    ///   - type: Type of the color.
    func color(for type: ColorStyle) -> UIColor
}

final class DefaultAppColor: AppColor {
    func color(for type: ColorStyle) -> UIColor {
        switch type {
        case .white:
            return .white
        case .background:
            return .black
        }
    }
}

protocol Styleable {
    /// Sets style for element.
    /// - Parameters:
    ///   - style: Style to be applied.
    func set(style: AppStyle)
}

// MARK: - UIView + Styleable

extension UIView: Styleable {
    func set(style: AppStyle) {}
}
