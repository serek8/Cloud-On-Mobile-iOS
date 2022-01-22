//
//  EmptyStateView.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/01/2022.
//

import UIKit

final class EmptyStateView: UIView {
    struct ViewModel: Hashable {
        /// Icon on top of the view.
        let icon: UIImage

        /// Subtitle displayed below icon.
        let subtitle: String
    }

    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let subtitleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .gray2)
        $0.font = AppStyle.current.font(for: .regular, size: 16)
        $0.accessibilityIdentifier = "subtitleLabel"
    }

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

extension EmptyStateView: Fillable {
    func fill(with model: ViewModel) {
        imageView.image = model.icon
        subtitleLabel.text = model.subtitle
    }
}

// MARK: - Private

private extension EmptyStateView {
    func setupView() {
        addSubviews([
            imageView,
            subtitleLabel
        ])

        imageView.addConstraints { [
            $0.equal(.top),
            $0.greaterThanOrEqual(.leading, constant: 16),
            $0.lessThanOrEqual(.bottom, constant: -16),
            $0.equal(.centerX),
            $0.equalConstant(.height, 120),
            $0.equalConstant(.width, 120)
        ] }

        subtitleLabel.addConstraints { [
            $0.equalTo(imageView, .top, .bottom, constant: 24),
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equal(.bottom)
        ] }
    }
}
