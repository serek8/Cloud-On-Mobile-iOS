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
    private let appColor: AppColor

    /// class responsible for creating fonts for style.
    private let appFont: AppFont

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

    func color(for type: ColorStyle) -> UIColor {
        appColor.color(for: type)
    }

    func font(for typography: TypographyStyle) -> UIFont {
        switch typography {
        case .heading1:
            return font(for: .semiBold, size: 32)
        case .headingTitleRegular:
            return font(for: .regular, size: 36)
        case .body16Regular,
             .buttonLarge:
            return font(for: .regular, size: 16)
        case .body14Regular,
             .link:
            return font(for: .regular, size: 14)
        }
    }
}

// MARK: - Private

private extension AppStyle {
    /// Do not make it public, instead create proper typography.
    func font(for type: FontStyle, size: CGFloat) -> UIFont {
        appFont.font(for: type, size: size)
    }
}
