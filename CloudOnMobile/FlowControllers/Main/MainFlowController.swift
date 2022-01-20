//
//  MainFlowController.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import UIKit

final class MainFlowController: FlowController {
    // MARK: - FlowController

    var parent: FlowController?

    var children: [FlowController] = []

    let navigationController: UINavigationController

    let presentation: FlowControllerPresentation

    private var onboardingCompleted: Bool {
        get {
            true
            /// - TODO: Uncomment code when onboarding will be ready
    //        dependencyContainer.appDefaults.onboardingCompleted
        }
        set {
            dependencyContainer.appDefaults.onboardingCompleted = newValue
        }
    }

    private let dependencyContainer: MainDependencyContainer

    private let window: UIWindow?

    /// Creates a new instance of a flow controller that is the root flow controller for the entire application.
    ///
    /// - Parameter window: key window of the application.
    /// - Parameter dependencyContainer: container with app dependencies.
    init(
        window: UIWindow?,
        dependencyContainer: MainDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        presentation = .root
        self.window = window

        if onboardingCompleted {
            presentMainScreen()
        } else {
            presentOnboarding()
        }
    }

    /// Presents the window on the screen.
    func present() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    /// Tells the delegate that the scene became active and is now responding to user events.
    func onSceneDidBecomeActive() {
        UIApplication.shared.isIdleTimerDisabled = true
        dependencyContainer.commandManager.reconnectIfNeeded()
    }
}

private extension MainFlowController {
    func presentMainScreen() {
        let mainPresenter = MainPresenter(commandManager: dependencyContainer.commandManager)
        let mainViewController = MainViewController(presenter: mainPresenter)
        mainPresenter.viewController = mainViewController

        let filesPresenter = FilesPresenter(filesDownloader: DefaultFilesDownloader(dataProvided: dependencyContainer.commandManager))
        let filesViewController = FilesViewController(presenter: filesPresenter)
        filesPresenter.viewController = filesViewController

        let sheetController = SheetPresentationController(
            backgroundViewController: mainViewController,
            sheetContentViewController: filesViewController
        )

        navigationController.setViewControllers([sheetController], animated: true)
    }

    func presentOnboarding() {
        let mainPresenter = OnboardingPresenter(
            eventHandler: { [weak self] event in
                switch event {
                case .onboardingDone:
                    self?.onboardingCompleted = true
                    self?.presentMainScreen()
                }
            }
        )
        let mainViewController = OnboardingViewController(presenter: mainPresenter)
        mainPresenter.viewController = mainViewController
        navigationController.setViewControllers([mainViewController], animated: false)
    }
}
