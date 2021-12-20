//
//  AppStyle.swift
//  PhoneDrive
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

final class AppStyle {
    /// Shared model of the style for app.
    static var current = AppStyle()

    /// class responsible for creating colors for style.
    let appColor: AppColor

    /// class responsible for creating fonts for style.
    let appFont: AppFont

    /// Initialize AppStyle
    /// - Parameters:
    ///   - appColor: class responsible for creating colors for style.
    ///   - appFont: class responsible for creating fonts for style.
    init(
        appColor: AppColor = DefaultAppColor(),
        appFont: AppFont = DefaultAppFont()
    ) {
        self.appColor = appColor
        self.appFont = appFont
    }
}
