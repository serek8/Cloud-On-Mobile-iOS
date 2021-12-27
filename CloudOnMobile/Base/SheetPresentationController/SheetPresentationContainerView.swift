//
//  SheetPresentationContainerView.swift
//  CloudOnMobile
//
//  Created by Karol P on 21/12/2021.
//

import UIKit

final class SheetPresentationContainerView: UIView {
    private enum Constants {
        static let scrollIndicatorHeight: CGFloat = 5
        static let cornerRadius: CGFloat = 48
    }

    private let topIndicator = with(UIView()) {
        $0.backgroundColor = AppStyle.current.color(for: .gray)
        $0.layer.cornerRadius = Constants.scrollIndicatorHeight / 2
        $0.layer.masksToBounds = true
    }

    private let container = UIView()

    init() {
        super.init(frame: .zero)
        setupView()
        setupUI()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fill(with view: UIView) {
        container.addSubview(view)
        view.addConstraints { $0.equalEdges() }
    }
}

// MARK: - Private

private extension SheetPresentationContainerView {
    func setupView() {
        addSubviews([topIndicator, container])

        topIndicator.addConstraints { [
            $0.equal(.top, constant: 8),
            $0.equalConstant(.width, 36),
            $0.equalConstant(.height, Constants.scrollIndicatorHeight),
            $0.equal(.centerX)
        ] }

        container.addConstraints { [
            $0.equalTo(topIndicator, .top, .bottom, constant: 24),
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.bottom)
        ] }
    }

    func setupUI() {
        backgroundColor = AppStyle.current.color(for: .white)
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
    }
}
