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
}

final class DefaultMainDependencyContainer: MainDependencyContainer {
    lazy var commandManager: CommandManager = {
        /// "192.168.50.10"
        CommandManager(url: "cloudon.cc")
    }()

    // MARK: - Private

    private lazy var urlSession = URLSession(configuration: .ephemeral)
}