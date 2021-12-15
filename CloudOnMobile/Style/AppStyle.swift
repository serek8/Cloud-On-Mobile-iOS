//
//  AppStyle.swift
//  PhoneDrive
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

final class AppStyle {
    static var current = AppStyle()

    let appFont: AppFont

    let appColor: AppColor

    init(
        appColor: AppColor = DefaultAppColor(),
        appFont: AppFont = DefaultAppFont()
    ) {
        self.appColor = appColor
        self.appFont = appFont
    }
}
