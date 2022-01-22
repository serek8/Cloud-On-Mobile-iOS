//
//  ErrorStateView.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/01/2022.
//

import UIKit

final class ErrorStateView: UIView {
    struct ViewModel {
        /// Icon on top of the view.
        let icon: UIImage

        /// Subtitle displayed below icon.
        let subtitle: String

        /// Title of the bottom button.
        let bottomButtonTitle: String

        /// Handler called on bottom button tapped.
        let bottomButtonHandler: () -> Void
    }

    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let subtitleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .heading1)
        $0.accessibilityIdentifier = "subtitleLabel"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let bottomButton = with(ViewsFactory.blueButton) {
        $0.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }

    private let containerView = UIView()

    private var bottomButtonHandler: (() -> Void)?

    init() {
        super.init(frame: .zero)
        backgroundColor = AppStyle.current.color(for: .white)
        setupView()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Fillable

extension ErrorStateView: Fillable {
    func fill(with model: ViewModel) {
        imageView.image = model.icon
        subtitleLabel.text = model.subtitle
        bottomButton.setTitle(model.bottomButtonTitle, for: .normal)
        bottomButtonHandler = model.bottomButtonHandler
    }
}

// MARK: - Private

private extension ErrorStateView {
    func setupView() {
        addSubviews([
            containerView,
            bottomButton
        ])

        containerView.addSubviews([
            imageView,
            subtitleLabel
        ])

        containerView.addConstraints { [
            $0.greaterThanOrEqual(.leading),
            $0.lessThanOrEqual(.trailing),
            $0.equal(.centerX),
            $0.equal(.centerY, constant: -40)
        ] }

        imageView.addConstraints { [
            $0.equal(.top),
            $0.greaterThanOrEqual(.leading),
            $0.lessThanOrEqual(.trailing),
            $0.equal(.centerX),
            $0.equalConstant(.height, 120),
            $0.equalConstant(.width, 120)
        ] }

        subtitleLabel.addConstraints { [
            $0.equalTo(imageView, .top, .bottom, constant: 24),
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.equal(.bottom)
        ] }

        bottomButton.addConstraints { [
            $0.equal(.centerX),
            $0.equal(.bottom, constant: -32)
        ] }
    }

    @objc func bottomButtonTapped() {
        bottomButtonHandler?()
    }
}
