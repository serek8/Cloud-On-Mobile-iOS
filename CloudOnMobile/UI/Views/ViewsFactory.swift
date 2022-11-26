//
//  ViewsFactory.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

enum ViewsFactory {
    static var blueButton: UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppStyle.current.font(for: .buttonLarge)
        button.setTitleColor(AppStyle.current.color(for: .white), for: .normal)
        button.backgroundColor = AppStyle.current.color(for: .blue)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 16,
            right: 24
        )
        return button
    }

    static var whiteButton: UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = AppStyle.current.font(for: .buttonLarge)
        button.setTitleColor(AppStyle.current.color(for: .blue), for: .normal)
        button.backgroundColor = AppStyle.current.color(for: .white)
        button.contentEdgeInsets = buttonContentEdgeInsets
        return button
    }
}

private extension ViewsFactory {
    static var buttonContentEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 16,
            right: 24
        )
    }
}
