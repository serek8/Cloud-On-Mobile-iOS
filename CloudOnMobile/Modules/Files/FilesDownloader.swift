//
//  FilesDownloader.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

struct DefaultFilesDownloader: FilesDownloader {

    private let dataProvider: FilesDataProvider

    /// Initialize DefaultFilesDownloader.
    /// - Parameters:
    ///   - <#statements#>: <#statements#>
    init(dataProvided: FilesDataProvider) {
        dataProvider = dataProvided
    }

    func getFilesList() async -> [File] {
        let result = dataProvider.listFiles()
        switch result {
        case let .success(files):
            return files.map {
                File(
                    name: $0.name,
                    size: Size(numberOfBytes: $0.size),
                    type: FileType(fileName: $0.name)
                )
            }
        case .failure:
            return []
        }
    }
}
