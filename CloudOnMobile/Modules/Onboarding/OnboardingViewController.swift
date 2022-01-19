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
        let onboardingPageModels: [OnboardingPageView.ViewModel]

        /// Title of the bottom button.
        let bottomButtonTitle: String

        /// Title of the skip button.
        let skipButtonTitle: String
    }

    private lazy var pageController = with(UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )) {
        $0.dataSource = self
        $0.delegate = self
    }

    private var controllers = [OnboardingPageViewController]()

    private var selectedController: OnboardingPageViewController? {
        pageController.viewControllers?.first as? OnboardingPageViewController
    }

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
            self.bottomButton.setTitle(model.bottomButtonTitle, for: .normal)
            self.skipButton.setTitle(model.skipButtonTitle, for: .normal)

            self.controllers = model.onboardingPageModels.map {
                let vc = OnboardingPageViewController()
                vc.onboardingPageView.fill(with: $0)
                return vc
            }
            self.pageController.setViewControllers([self.controllers[0]], direction: .forward, animated: false)
        }
    }
}

// MARK: - Private

private extension OnboardingViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)

        addChild(pageController)

        containerView.addSubviews([
            pageController.view,
            bottomButton,
            skipButton
        ])

        pageController.view.addConstraints { [
            $0.equal(.leading),
            $0.equal(.trailing),
            $0.equalTo(bottomButton, .bottom, .top, constant: -48),
            $0.equalTo(skipButton, .top, .bottom)
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
        guard
            let selectedController = selectedController,
            let currentIndex = controllers.firstIndex(of: selectedController)
        else {
            return
        }

        let nextIndex = controllers.index(after: currentIndex)

        guard controllers.count > nextIndex else { return }

        scroll(to: controllers[nextIndex])
    }

    @objc func skipButtonTapped() {
        presenter.skipTapped()
    }
}


extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageViewController = viewController as? OnboardingPageViewController,
            let index = controllers.firstIndex(of: pageViewController),
            index > 0
        else {
            return nil
        }
        return controllers[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageViewController = viewController as? OnboardingPageViewController,
            let index = controllers.firstIndex(of: pageViewController),
            index < controllers.count - 1
        else {
            return nil
        }
        return controllers[index + 1]
    }
}


// MARK: Private

private extension OnboardingViewController {
    func scroll(to page: OnboardingPageViewController) {
        guard
            let presentedViewController = selectedController,
            let fromIndex = controllers.firstIndex(of: presentedViewController),
            let toIndex = controllers.firstIndex(of: page),
            fromIndex != toIndex
        else {
            return
        }

        let direction: UIPageViewController.NavigationDirection = toIndex > fromIndex ? .forward : .reverse
        pageController.setViewControllers([page], direction: direction, animated: true, completion: nil)
    }
}
