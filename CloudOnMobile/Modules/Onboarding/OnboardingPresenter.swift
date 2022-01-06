//
//  OnboardingPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import Foundation

protocol OnboardingPresenterProtocol: PresenterProtocol {
    /// Function called on bottom button tapped.
    func bottomButtonTapped()
}

final class OnboardingPresenter {
    weak var viewController: OnboardingViewController?
}

// MARK: MainPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func refreshData() {
        let page = OnboardingPage.intro
        viewController?.fill(
            with: OnboardingViewController.ViewModel(
                image: page.image,
                numberOfFilledDots: page.index,
                title: page.title,
                description: page.description,
                nextButtonTitle: "Next"
            )
        )
    }

    func bottomButtonTapped() {
        print("Next")
    }
}
