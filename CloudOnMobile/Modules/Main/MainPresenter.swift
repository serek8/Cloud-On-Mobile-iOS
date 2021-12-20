//
//  MainPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import Foundation

final class MainPresenter {
    weak var viewController: MainViewController?

    private let commandManager: CommandManager

    /// Initialize Presenter
    /// - Parameters:
    ///   - commandManager: responsible for communicatio with server.
    init(commandManager: CommandManager) {
        self.commandManager = commandManager
    }
}

// MARK: PresenterProtocol

extension MainPresenter: PresenterProtocol {
    func refreshData() {}
}
