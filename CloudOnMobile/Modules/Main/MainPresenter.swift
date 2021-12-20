//
//  MainPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import Foundation

protocol MainPresenterProtocol: PresenterProtocol {
    /// Gets access code.
    func getAccessCode() async -> String
}

final class MainPresenter {
    weak var viewController: MainViewController?

    private let commandManager: CommandManager

    /// Initialize Presenter
    /// - Parameters:
    ///   - commandManager: responsible for communicatio with server.
    init(commandManager: CommandManager) {
        self.commandManager = commandManager
        commandManager.reconnectIfNeeded()
    }
}

// MARK: MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func refreshData() {}

    func getAccessCode() async -> String {
        "XD"
    }
}
