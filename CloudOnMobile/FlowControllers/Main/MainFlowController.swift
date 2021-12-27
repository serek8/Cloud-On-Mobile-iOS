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
        presentation = .root
        self.window = window
        presentMainScreen()
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
        let presenter = MainPresenter(commandManager: dependencyContainer.commandManager)
        let viewController = MainViewController(presenter: presenter)
        presenter.viewController = viewController
        navigationController.setViewControllers([viewController], animated: false)
    }
}
