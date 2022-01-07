//
//  OnboardingViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    struct ViewModel {
        /// Model of the onboarding page.
        let onboardingPageModel: OnboardingPageView.ViewModel

        /// Title of the bottom button.
        let bottomButtonTitle: String

        /// Title of the skip button.
        let skipButtonTitle: String
    }

    private let onboardingView = OnboardingPageView()

    private let bottomButton = with(ViewsFactory.blueButton) {
        $0.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }

    private let skipButton = with(ViewsFactory.whiteButton) {
        $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
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
            self.onboardingView.fill(with: model.onboardingPageModel)
            self.bottomButton.setTitle(model.bottomButtonTitle, for: .normal)
            self.skipButton.setTitle(model.skipButtonTitle, for: .normal)
        }
    }
}

// MARK: - Private

private extension OnboardingViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)

        containerView.addSubviews([
            onboardingView,
            bottomButton,
            skipButton
        ])

        onboardingView.addConstraints { [
            $0.equal(.leading, constant: 16),
            $0.equal(.trailing, constant: -16),
            $0.equalTo(bottomButton, .bottom, .top, constant: -48)
        ] }

        bottomButton.addConstraints { [
            $0.equal(.centerX),
            $0.equal(.bottom, constant: -66)
        ] }

        skipButton.addConstraints { [
            $0.equal(.safeAreaTop),
            $0.equal(.trailing)
        ] }
    }

    @objc func bottomButtonTapped() {
        presenter.bottomButtonTapped()
    }

    @objc func skipButtonTapped() {
        presenter.skipTapped()
    }
}

