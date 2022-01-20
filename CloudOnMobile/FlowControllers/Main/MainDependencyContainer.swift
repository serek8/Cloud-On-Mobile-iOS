//
//  MainDependencyContainer.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import Foundation

/// Dependency container for MainFlowController.
protocol MainDependencyContainer {
    /// Class responsible for connection with server.
    var commandManager: CommandManager { get }

    /// Class responsible for interaction with UserDefaults.
    var appDefaults: AppDefaults { get }
}

final class DefaultMainDependencyContainer: MainDependencyContainer {
    lazy var commandManager: CommandManager = {
      CommandManager(url: appSchemeProperties.host, port: appSchemeProperties.port)
    }()

    lazy var appDefaults: AppDefaults = {
        DefaultAppDefaults(userDefaults: .standard)
    }()

    // MARK: - Private

    private lazy var urlSession = URLSession(configuration: .ephemeral)

    private lazy var appSchemeProperties: AppSchemeProperties = DefaultAppSchemeProperties()
}
