//
//  BaseView.swift
//  CloudOnMobile
//
//  Created by Karol P on 15/12/2021.
//

import UIKit

class BaseView: UIView {
    /// Style of the view.
    let style: AppStyle

    /// Initialize BaseView
    /// - Parameters:
    ///   - style: style to be configured with view.
    init(
        style: AppStyle = AppStyle.current
    ) {
        self.style = style
        super.init(frame: .zero)
        setupStyle()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Setups style for view.
    /// Function called on init.
    func setupStyle() {
        backgroundColor = style.appColor.color(for: .background)
    }
}
