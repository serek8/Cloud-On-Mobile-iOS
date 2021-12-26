//
//  IconTitleSubtitleView.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

typealias IconTitleSubtitleTableViewCell = BaseTableViewCell<IconTitleSubtitleView>

final class IconTitleSubtitleView: UIView {
    struct ViewModel: Hashable {
        /// Icon on the left side.
        let icon: UIImage

        /// Title of the view.
        let title: String

        /// Subtitle of the view.
        let subtitle: String
    }

    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .regular, size: 16)
        $0.accessibilityIdentifier = "titleLabel"
    }

    private let subtitleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .gray2)
        $0.font = AppStyle.current.font(for: .regular, size: 16)
        $0.accessibilityIdentifier = "subtitleLabel"
    }

    private let separator = with(UIView()) {
        $0.backgroundColor = AppStyle.current.color(for: .gray3)
    }

    init() {
        super.init(frame: .zero)
        setupView()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Fillable

extension IconTitleSubtitleView: Fillable {
    func fill(with model: ViewModel) {
        imageView.image = model.icon
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}

// MARK: - Private

private extension IconTitleSubtitleView {
    func setupView() {
        addSubviews([
            imageView,
            titleLabel,
            subtitleLabel,
            separator
        ])

        imageView.addConstraints { [
            $0.equal(.top, constant: 16),
            $0.equal(.leading, constant: 16),
            $0.equal(.bottom, constant: -24),
            $0.equalConstant(.height, 40),
            $0.equalConstant(.width, 40)
        ] }

        titleLabel.addConstraints { [
            $0.equalTo(imageView, .top, .top),
            $0.equalTo(imageView, .leading, .trailing, constant: 16),
            $0.equal(.trailing, constant: -16)
        ] }

        subtitleLabel.addConstraints { [
            $0.equalTo(titleLabel, .top, .bottom),
            $0.equalTo(imageView, .leading, .trailing, constant: 16),
            $0.equal(.trailing, constant: -16)
        ] }

        separator.addConstraints { [
            $0.equalTo(imageView, .leading, .leading),
            $0.equalTo(subtitleLabel, .trailing, .trailing),
            $0.equal(.bottom),
            $0.equalConstant(.height, 1)
        ] }
    }
}
