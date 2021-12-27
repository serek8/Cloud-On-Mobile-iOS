//
//  FilesViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

final class FilesViewController: BaseViewController {
    private let tableView = with(UITableView()) {
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorColor = .clear
        $0.allowsSelection = true
        $0.backgroundColor = AppStyle.current.color(for: .white)
        $0.backgroundView?.backgroundColor = AppStyle.current.color(for: .white)
    }

    private let presenter: FilesPresenter

    init(presenter: FilesPresenter) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Private

private extension FilesViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)
        containerView.addSubview(tableView)
    }
}
