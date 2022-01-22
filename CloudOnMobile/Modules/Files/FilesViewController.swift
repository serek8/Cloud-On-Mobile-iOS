//
//  FilesViewController.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

protocol FilesViewControllerProtocol: AnyObject, StatePresentableView {
    /// Fills view with model.
    /// - Parameters:
    ///   - model: model containing data to properly display view.
    func fill(with model: [IconTitleSubtitleView.ViewModel])
}

final class FilesViewController: BaseTableViewController {
    private let emptyView = EmptyStateView()

    private let errorView = ErrorStateView()

    private var files: [IconTitleSubtitleView.ViewModel] = []

    private let presenter: FilesPresenter

    init(presenter: FilesPresenter) {
        self.presenter = presenter
        super.init(presenter: presenter)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupStateViews()
        Task {
            await presenter.refreshData()
        }
    }
}

// MARK: - FilesViewControllerProtocol

extension FilesViewController: FilesViewControllerProtocol {
    var emptyStateView: UIView { emptyView }

    var errorStateView: UIView { errorView }

    func fill(with model: [IconTitleSubtitleView.ViewModel]) {
        files = model
        DispatchQueue.main.async {
            self.rootTableView.reloadData()
        }
    }

    func showEmptyState() {
        DispatchQueue.main.async {
            self.clearState()
            self.rootTableView.backgroundView = self.emptyStateView
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
        rootTableView
    }
}

// MARK: - Private

private extension FilesViewController {
    func setupViews() {
        rootTableView.dataSource = self
    }

    func setupStateViews() {
        emptyView.fill(
            with: EmptyStateView.ViewModel(
                icon: UIImage(imageLiteralResourceName: "files"),
                subtitle: "There are no items here!"
            )
        )

        errorView.fill(
            with: ErrorStateView.ViewModel(
                icon: UIImage(imageLiteralResourceName: "errorState"),
                subtitle: "Something went wrong :(",
                bottomButtonTitle: "Retry",
                bottomButtonHandler: {
                    Task { [weak self] in
                        await self?.refreshData()
                    }
                }
            )
        )
    }
}
