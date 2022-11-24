//
//  FilesViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

protocol FilesViewControllerProtocol: AnyObject {
    func fill(with model: [IconTitleSubtitleView.ViewModel])
}

final class FilesViewController: BaseViewController, FilesViewControllerProtocol {
    private var files: [IconTitleSubtitleView.ViewModel] = []

    private let refreshControl = UIRefreshControl()

    private let tableView = with(UITableView()) {
        $0.rowHeight = UITableView.automaticDimension
        $0.allowsSelection = true
        $0.backgroundColor = AppStyle.current.color(for: .white)
        $0.backgroundView?.backgroundColor = AppStyle.current.color(for: .white)
        $0.separatorStyle = .none
    }

    private let presenter: FilesPresenter

    init(presenter: FilesPresenter) {
        self.presenter = presenter
        super.init(presenter: presenter)
        NotificationCenter.default.addObserver(self, selector: #selector(didImportNewFile), name: NSNotification.Name(rawValue: "imported-new-file"), object: nil)
    }

    @objc func didImportNewFile() {
        Task {
            await presenter.refreshData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task {
            await presenter.refreshData()
        }
    }
}

extension FilesViewController {
    func fill(with model: [IconTitleSubtitleView.ViewModel]) {
        files = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

// MARK: ScrollableViewController

extension FilesViewController: ScrollableViewController {
    var scrollView: UIScrollView? {
        tableView
    }
}

// MARK: - Private

private extension FilesViewController {
    func setupViews() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)
        containerView.addSubview(tableView)

        tableView.addConstraints { $0.equalEdges() }
        tableView.dataSource = self

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    // MARK: - Private objc

    @objc func refreshData() {
        Task { [weak self] in
            await self?.presenter.refreshData()
            self?.refreshControl.endRefreshing()
        }
    }
}
