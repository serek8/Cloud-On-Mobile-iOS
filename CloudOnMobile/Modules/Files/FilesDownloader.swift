//
//  FilesDownloader.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

struct DefaultFilesDownloader: FilesDownloader {
    private struct BackendFile: Codable {
        /// Name of the file.
        let name: String

        /// Size of the file in bytes.
        let size: Int64
    }

    private let dataProvider: FilesDataProvider

    /// Initialize DefaultFilesDownloader.
    /// - Parameters:
    ///   - <#statements#>: <#statements#>
    init(dataProvided: FilesDataProvider) {
        dataProvider = dataProvided
    }

    func getFilesList() async -> [File] {
        guard let data = dataProvider.listFiles() else { return [] }
        let decoder = JSONDecoder()
        let files = try? decoder.decode([BackendFile].self, from: data)
        return files?.map {
            File(
                name: $0.name,
                size: Size(numberOfBytes: $0.size),
                type: FileType(fileName: $0.name)
            )
        } ?? []
    }
}
