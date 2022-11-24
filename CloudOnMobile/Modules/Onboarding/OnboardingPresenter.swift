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
    /// Function called when selected index of the page view has changed.
    /// - Parameters:
    ///   - newIndex: new selected index.
    func indexChanged(to newIndex: Int)

    /// Function called on finish tapped.
    func finishTapped()
}

final class OnboardingPresenter {
    weak var viewController: OnboardingViewControllerProtocol?

    private let onboardingPages: [OnboardingPage] = OnboardingPage.allCases

    private let eventHandler: (OnboardingEvent) -> Void

    /// Initialised OnboardingPresenter.
    /// - Parameters:
    ///   - eventHandler: handler called for requesting action outside of screen.
    init(eventHandler: @escaping (OnboardingEvent) -> Void) {
        self.eventHandler = eventHandler
    }
}

// MARK: OnboardingPresenterProtocol

extension OnboardingPresenter: OnboardingPresenterProtocol {
    func refreshData() {
        let onboardingPageModels = onboardingPages.map { page in
            OnboardingPageView.ViewModel(
                image: page.image,
                title: page.title,
                description: page.description
            )
        }
        viewController?.fill(
            with: OnboardingViewController.ViewModel(
                onboardingPageModels: onboardingPageModels,
                skipButtonTitle: L10n.Onboarding.skip
            )
        )
        viewController?.setBottomButtonTitle(title: L10n.Onboarding.next)
    }

    func indexChanged(to newIndex: Int) {
        let isLastPage = onboardingPages.count - 1 == newIndex

        if isLastPage {
            viewController?.setBottomButtonTitle(title: L10n.Onboarding.start)
        } else {
            viewController?.setBottomButtonTitle(title: L10n.Onboarding.next)
        }
    }

    func finishTapped() {
        eventHandler(.onboardingDone)
    }
}
