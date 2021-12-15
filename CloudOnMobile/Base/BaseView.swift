//
//  BaseView.swift
//  CloudOnMobile
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

class BaseView: UIView {
    let style: AppStyle

    init(
        style: AppStyle = AppStyle.current
    ) {
        self.style = style
        super.init(frame: .zero)
        setupStyle()
    }

    @available(*, unavailable)  required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupStyle() {
        backgroundColor = style.appColor.color(for: .background)
    }
}
