//
//  MainViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 20/12/2021.
//

import Foundation

final class MainViewController: BaseViewController<MainPresenter> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private

private extension MainViewController {
    func setupViews() {
        view.backgroundColor = Sty
    }
}
