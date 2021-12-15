//
//  Presenter.swift
//  PhoneDrive
//
//  Created by Karol P on 09/12/2021.
//

import Foundation

/// Protocol describes presenter structure.
protocol PresenterProtocol {
    /// Requests refresh of the data.
    func refreshData()

    /// Function called on viewDidLoad.
    func onViewDidLoad()

    /// Function called on viewWillAppear.
    func onViewWillAppear()

    /// Function called on viewDidAppear
    func onViewDidAppear()

    /// Function called on viewDidDisappear
    func onViewDidDisappear()
}

extension PresenterProtocol {
    func onViewDidLoad() {}

    func onViewWillAppear() {
        refreshData()
    }

    func onViewDidAppear() {}

    func onViewDidDisappear() {}
}
