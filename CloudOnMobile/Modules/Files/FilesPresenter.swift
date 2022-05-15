//
//  FilesPresenter.swift
//  CloudOnMobile
//
//  Created by Karol P on 22/12/2021.
//

import UIKit

protocol FilesDownloader {
    /// Downloads list files from server.
    func getFilesList() async -> Result<[File], Error>
}

final class FilesPresenter: PresenterProtocol {
    weak var viewController: FilesViewControllerProtocol?

    private let filesDownloader: FilesDownloader

    init(filesDownloader: FilesDownloader) {
        self.filesDownloader = filesDownloader
    }

    func refreshData() async {
        let result = await filesDownloader.getFilesList()
        switch result {
        case let .success(files):
            if files.isEmpty {
                viewController?.showEmptyState()
            } else {
                viewController?.fill(
                    with: map(files: files)
                )
            }
        case .failure:
            viewController?.showErrorState()
        }
    }
}

// MARK: - Private

private extension FilesPresenter {
    func map(files: [File]) -> [IconTitleSubtitleView.ViewModel] {
        files.map {
            IconTitleSubtitleView.ViewModel(
                icon: $0.type.image,
                title: $0.name,
                subtitle: $0.size.translation
            )
        }
    }
}
