//
//  OnboardingViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import UIKit

protocol OnboardingViewControllerProtocol: NSObject {
    /// Sets bottom button title.
    /// - Parameters:
    ///   - title: Title for the button.
    func setBottomButtonTitle(title: String)

    /// Fills view with model.
    /// - Parameters:
    ///   - model: Model for the view.
    func fill(with model: OnboardingViewController.ViewModel)
}

final class OnboardingViewController: BaseViewController {
    struct ViewModel {
        /// Model of the onboarding page.
        let onboardingPageModels: [OnboardingPageView.ViewModel]

        /// Title of the skip button.
        let skipButtonTitle: String
    }

    private lazy var pageViewController = with(UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )) {
        $0.dataSource = self
        $0.delegate = self
    }

    private var onboardingPages = [OnboardingPageViewController]()

    private lazy var bottomButton = {
        let button = ViewsFactory.blueButton
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var skipButton = {
        let button = ViewsFactory.whiteButton
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()

    private let presenter: OnboardingPresenterProtocol

    init(presenter: OnboardingPresenterProtocol) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPageControlUI()
    }
}

// MARK: OnboardingViewControllerProtocol

extension OnboardingViewController: OnboardingViewControllerProtocol {
    func fill(with model: ViewModel) {
        DispatchQueue.main.async {
            self.skipButton.setTitle(model.skipButtonTitle, for: .normal)

            self.onboardingPages = model.onboardingPageModels.map {
                let vc = OnboardingPageViewController()
                vc.onboardingPageView.fill(with: $0)
                return vc
            }
            self.pageViewController.setViewControllers([self.onboardingPages[0]], direction: .forward, animated: false)
        }
    }

    func setBottomButtonTitle(title: String) {
        DispatchQueue.main.async {
            self.bottomButton.setTitle(title, for: .normal)
        }
    }
}

// MARK: UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard
            let page = pageViewController.selectedPage,
            let index = onboardingPages.firstIndex(of: page)
        else {
            return
        }
        presenter.indexChanged(to: index)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageViewController = viewController as? OnboardingPageViewController,
            let index = onboardingPages.firstIndex(of: pageViewController),
            index > 0
        else {
            return nil
        }
        return onboardingPages[index - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let pageViewController = viewController as? OnboardingPageViewController,
            let index = onboardingPages.firstIndex(of: pageViewController),
            index < onboardingPages.count - 1
        else {
            return nil
        }
        return onboardingPages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        onboardingPages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard
            let selectedController = pageViewController.selectedPage,
            onboardingPages.count > 0
        else {
            return 0
        }
        return onboardingPages.firstIndex(of: selectedController) ?? 0
    }
}

// MARK: Private

private extension OnboardingViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)

        addChild(pageViewController)

        containerView.addSubviews([
            pageViewController.view,
            bottomButton,
            skipButton
        ])

        pageViewController.view.addConstraints { [
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

    func setupPageControlUI() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = AppStyle.current.color(for: .gray)
        appearance.currentPageIndicatorTintColor = AppStyle.current.color(for: .black)
    }

    func scroll(to page: OnboardingPageViewController) {
        guard
            let presentedViewController = pageViewController.selectedPage,
            let fromIndex = onboardingPages.firstIndex(of: presentedViewController),
            let toIndex = onboardingPages.firstIndex(of: page),
            fromIndex != toIndex
        else {
            return
        }

        let direction: UIPageViewController.NavigationDirection = toIndex > fromIndex ? .forward : .reverse
        pageViewController.setViewControllers([page], direction: direction, animated: true, completion: nil)
        presenter.indexChanged(to: toIndex)
    }

    @objc func bottomButtonTapped() {
        guard
            let selectedController = pageViewController.selectedPage,
            let currentIndex = onboardingPages.firstIndex(of: selectedController)
        else {
            return
        }

        let nextIndex = onboardingPages.index(after: currentIndex)

        if onboardingPages.count > nextIndex {
            scroll(to: onboardingPages[nextIndex])
        } else {
            presenter.finishTapped()
        }
    }

    @objc func skipButtonTapped() {
        presenter.finishTapped()
    }
}

private extension UIPageViewController {
    var selectedPage: OnboardingPageViewController? {
        viewControllers?.first as? OnboardingPageViewController
    }
}
