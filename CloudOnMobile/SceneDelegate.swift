//
//  SceneDelegate.swift
//  CloudOnMobile
//
//  Created by Cloud On Mobile Team on 18/12/2020.
//

import UIKit

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var mainFlowController: MainFlowController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        mainFlowController = MainFlowController(
            window: window,
            dependencyContainer: DefaultMainDependencyContainer()
        )
        mainFlowController?.present()
    }
}
