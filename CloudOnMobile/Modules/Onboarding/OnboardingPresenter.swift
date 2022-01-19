//
//  OnboardingPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import Foundation

enum OnboardingEvent {
    case onboardingDone
}

protocol OnboardingPresenterProtocol: PresenterProtocol {
    /// Function called on bottom button tapped.
    func bottomButtonTapped()

    /// Function called on skip button tapped.
    func skipTapped()
}

final class OnboardingPresenter {
    weak var viewController: OnboardingViewController?

    private let eventHandler: (OnboardingEvent) -> Void

    /// Initialised OnboardingPresenter.
    /// - Parameters:
    ///   - eventHandler: handler called for requesting action outside of screen.
    init(eventHandler: @escaping (OnboardingEvent) -> Void) {
        self.eventHandler = eventHandler
    }
}

// MARK: MainPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func refreshData() {
        let onboardingPageModels = OnboardingPage.allCases.map { page in
            OnboardingPageView.ViewModel(
                image: page.image,
                title: page.title,
                description: page.description
            )
        }
        viewController?.fill(
            with: OnboardingViewController.ViewModel(
                onboardingPageModels: onboardingPageModels,
                bottomButtonTitle: "Next",
                skipButtonTitle: "Skip"
            )
        )
    }

    func bottomButtonTapped() {
        print("Next")
    }

    func skipTapped() {
        eventHandler(.onboardingDone)
    }
}
