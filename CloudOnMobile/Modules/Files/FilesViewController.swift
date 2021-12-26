//
//  FilesViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

final class FilesViewController: BaseViewController {
    private var files: [IconTitleSubtitleView.ViewModel] = []

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

// MARK: Fillable

extension FilesViewController: Fillable {
    func fill(with model: [IconTitleSubtitleView.ViewModel]) {
        files = model
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource

extension FilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = files[indexPath.row]
        let cell = tableView.getReusableCellSafe(cellType: IconTitleSubtitleTableViewCell.self)
        cell.fill(with: model)
        return cell
    }
}

// MARK: - Private

private extension FilesViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)
        containerView.addSubview(tableView)

        tableView.addConstraints { $0.equalEdges() }
        tableView.dataSource = self
    }
}
