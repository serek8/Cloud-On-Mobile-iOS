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
        navigationController.navigationBar.isHidden = true
        presentation = .root
        self.window = window
        presentMainScreen()
    }

    /// Presents the window on the screen.
    func present() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

private extension MainFlowController {
    func presentMainScreen() {
        let mainPresenter = MainPresenter(commandManager: dependencyContainer.commandManager)
        let mainViewController = MainViewController(presenter: mainPresenter)
        mainPresenter.viewController = mainViewController

        let filesPresenter = FilesPresenter()
        let filesViewController = FilesViewController(presenter: filesPresenter)

        let sheetController = SheetPresentationController(
            backgroundViewController: mainViewController,
            sheetContentViewController: filesViewController
        )

        navigationController.setViewControllers([sheetController], animated: false)
    }
}
