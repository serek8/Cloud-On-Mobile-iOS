//
//  OnboardingPageView.swift
//  CloudOnMobile
//
//  Created by Karol P on 07/01/2022.
//

import UIKit

final class OnboardingPageView: UIView {
    struct ViewModel: Hashable {
        /// Image on top of the view.
        let image: UIImage

        /// Title of the view.
        let title: String

        /// Description of the view.
        let description: String
    }

    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .heading1)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private let descriptionLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .body16Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.addCharactersSpacing(value: 26)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Fillable

extension OnboardingPageView: Fillable {
    func fill(with model: ViewModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - Private

private extension OnboardingPageView {
    func setupView() {
        addSubviews([
            imageView,
            titleLabel,
            descriptionLabel
        ])

        imageView.addConstraints { [
            $0.equal(.top, constant: 48),
            $0.equal(.centerX),
            $0.equalTo(titleLabel, .bottom, .top, constant: -28),
            $0.equalTo(imageView, .height, .width)
        ] }

        titleLabel.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.equalTo(descriptionLabel, .bottom, .top, constant: -28)
        ] }

        descriptionLabel.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.lessThanOrEqual(.bottom)
        ] }
    }
}
