//
//  FilesDownloader.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

struct MockedFilesDownloader: FilesDownloader {
    /// - TODO: Connect downloading files to FilesDownloader.

    func getFilesList() async -> [File] {
        guard let data = listFiles() else { return [] }
        let decoder = JSONDecoder()
        let files = try? decoder.decode([File].self, from: data)
        return files ?? []
    }
}
