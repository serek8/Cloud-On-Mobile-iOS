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
            return .white
        case .background:
            return .black
        case .blue:
            return UIColor(red: 0.055, green: 0.439, blue: 0.945, alpha: 1)
        }
    }
}
