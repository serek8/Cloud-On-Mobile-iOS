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

    private let titleLabel = with(UILabel()) {
        $0.accessibilityIdentifier = "titleLabel"
    }

    private let subtitleLabel = with(UILabel()) {
        $0.accessibilityIdentifier = "subtitleLabel"
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
        /// model.icon
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
    }
}

// MARK: - Private

private extension IconTitleSubtitleView {
    func setupView() {
        addSubviews([
            titleLabel,
            subtitleLabel
        ])

        titleLabel.addConstraints { [
            $0.equal(.top),
            $0.equal(.leading),
            $0.lessThanOrEqual(.trailing)
        ] }

        subtitleLabel.addConstraints { [
            $0.equalTo(titleLabel, .top, .bottom),
            $0.equal(.leading),
            $0.lessThanOrEqual(.trailing),
            $0.equal(.bottom)
        ] }
    }
}
