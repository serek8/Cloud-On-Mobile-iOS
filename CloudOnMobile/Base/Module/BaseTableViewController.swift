//
//  BaseTableViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/01/2022.
//

import UIKit

class BaseTableViewController: BaseViewController {
    // MARK: - Properties

    let rootTableView: UITableView

    private let refreshControl = UIRefreshControl()

    // MARK: - Initialization

    init(
        presenter: PresenterProtocol,
        tableViewStyle: UITableView.Style = .plain
    ) {
        rootTableView = with(UITableView(frame: .zero, style: tableViewStyle)) {
            $0.rowHeight = UITableView.automaticDimension
            $0.allowsSelection = true
            $0.backgroundColor = AppStyle.current.color(for: .white)
            $0.backgroundView?.backgroundColor = AppStyle.current.color(for: .white)
            $0.separatorStyle = .none
        }
        super.init(presenter: presenter)
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Private objc

    @objc private func refreshControlHandler() {
        Task { [weak self] in
            await self?.refreshData()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Private

private extension BaseTableViewController {
    func setupTableView() {
        containerView.backgroundColor = AppStyle.current.color(for: .white)
        containerView.addSubview(rootTableView)
        rootTableView.addConstraints { $0.equalEdges() }
        rootTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)
    }
}
