//
//  MainPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import Foundation

protocol MainPresenterProtocol: PresenterProtocol {
    /// Gets access code.
    func getAccessCode() async -> Result<String, Error>
}

final class MainPresenter {
    enum MainPresenterError: LocalizedError {
        case fetchingAccessCode
    }

    weak var viewController: MainViewController?

    private let commandManager: CommandManager

    /// Initialize Presenter
    /// - Parameters:
    ///   - commandManager: responsible for communication with server.
    init(commandManager: CommandManager) {
        self.commandManager = commandManager
    }
}

// MARK: MainPresenterProtocol

extension MainPresenter: MainPresenterProtocol {
    func refreshData() {}

    func getAccessCode() async -> Result<String, Error> {
        do {
            let code = try await commandManager.connect()
            return .success("\(code)")
        } catch {
            return .failure(MainPresenterError.fetchingAccessCode)
        }
    }
}

extension MainPresenter.MainPresenterError {
    var localizedDescription: String {
        switch self {
        case .fetchingAccessCode:
            return "Fetching access code failed"
        }
    }
}
