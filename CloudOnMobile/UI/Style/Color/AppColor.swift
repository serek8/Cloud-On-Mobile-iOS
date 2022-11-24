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

struct DefaultAppColor: AppColor {
    func color(for type: ColorStyle) -> UIColor {
        switch type {
        case .white:
            return UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        case .background:
            return UIColor(red: 3 / 255, green: 14 / 255, blue: 29 / 255, alpha: 1)
        case .black:
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        case .blue:
            return UIColor(red: 0.055, green: 0.439, blue: 0.945, alpha: 1)
        case .gray:
            return UIColor(red: 0.753, green: 0.757, blue: 0.761, alpha: 1)
        case .gray2:
            return UIColor(red: 112 / 255, green: 108 / 255, blue: 108 / 255, alpha: 1)
        case .gray3:
            return UIColor(red: 242 / 255, green: 242 / 255, blue: 243 / 255, alpha: 1)
        }
    }
}
