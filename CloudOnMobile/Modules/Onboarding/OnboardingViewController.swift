//
//  OnboardingViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    struct ViewModel {
        /// Image presented on top of screen.
        let image: UIImage

        /// - TODO: Change to DotsViewModel
        let numberOfFilledDots: Int

        /// Title of the view.
        let title: String

        /// Description of the view.
        let description: String

        let nextButtonTitle: String
    }

    private let imageView = with(UIImageView()) {
        $0.contentMode = .scaleAspectFit
    }

    private let dotsView = with(UIView()) {
        $0.backgroundColor = .gray
    }

    private let titleLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .regular, size: 32)
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }

    private let descriptionLabel = with(UILabel()) {
        $0.textColor = AppStyle.current.color(for: .black)
        $0.font = AppStyle.current.font(for: .regular, size: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.addCharactersSpacing(value: 26)
    }

    private let bottomButton = with(UIButton(type: .system)) {
        $0.titleLabel?.font = AppStyle.current.font(for: .regular, size: 16)
        $0.setTitleColor(AppStyle.current.color(for: .white), for: .normal)
        $0.backgroundColor = AppStyle.current.color(for: .blue)
        $0.layer.cornerRadius = 12
        $0.contentEdgeInsets = UIEdgeInsets(
            top: 16,
            left: 24,
            bottom: 16,
            right: 24
        )
        $0.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }

    private let presenter: OnboardingPresenterProtocol

    init(presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Fillable

extension OnboardingViewController: Fillable {
    func fill(with model: ViewModel) {
        DispatchQueue.main.async {
            self.imageView.image = model.image
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.description
            self.bottomButton.setTitle(model.nextButtonTitle, for: .normal)
        }
    }
}

// MARK: - Private

private extension OnboardingViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)

        containerView.addSubviews([
            imageView,
            dotsView,
            titleLabel,
            descriptionLabel,
            bottomButton
        ])

        imageView.addConstraints { [
            $0.equalConstant(.height, 216),
            $0.equalTo(imageView, .height, .width),
            $0.equal(.centerX),
            $0.equalTo(titleLabel, .bottom, .top, constant: -28)
        ] }

        dotsView.addConstraints { [
            $0.equal(.centerX),
            $0.equalTo(titleLabel, .bottom, .top, constant: -28),
            $0.equalConstant(.height, 1)
        ] }

        titleLabel.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.equalTo(descriptionLabel, .bottom, .top, constant: -28)
        ] }

        descriptionLabel.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.equalTo(bottomButton, .bottom, .top, constant: -48)
        ] }

        bottomButton.addConstraints { [
            $0.equal(.centerX),
            $0.equal(.bottom, constant: -66)
        ] }
    }

    @objc func bottomButtonTapped() {
        presenter.bottomButtonTapped()
    }
}
