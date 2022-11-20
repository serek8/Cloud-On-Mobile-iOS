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

    func sceneDidBecomeActive(_ scene: UIScene) {
        mainFlowController?.onSceneDidBecomeActive()
    }
  
  
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let file = URLContexts.first{
      if let data = try? Data.init(contentsOf: file.url){
        let fileMngr = FileManager.default
        let documentsDirectory = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let urlImprotedFile = documentsDirectory.appendingPathComponent(file.url.lastPathComponent)
        try? data.write(to: urlImprotedFile)
      }
    }
    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue:"imported-new-file"), object: nil)
  }
}
