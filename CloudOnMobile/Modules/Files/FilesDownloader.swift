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
    ///   - dataProvided: Files data provider.
    init(dataProvided: FilesDataProvider) {
        dataProvider = dataProvided
    }

    func getFilesList() async -> Result<[File], Error> {
        dataProvider
            .listFiles()
            .flatMap { backendModel in
                let files = backendModel.map {
                    File(
                        name: $0.name,
                        size: Size(numberOfBytes: $0.size),
                        type: FileType(fileName: $0.name)
                    )
                }
                return .success(files)
            }
            .flatMapError {
                .failure($0)
            }
    }
}
