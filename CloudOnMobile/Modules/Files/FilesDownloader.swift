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
        [
            File(
                name: "mexico.jpg",
                size: Size(),
                type: .image
            ),
            File(
                name: "video.mp4",
                size: Size(),
                type: .video
            ),
            File(
                name: "music.mp3",
                size: Size(),
                type: .music
            ),
            File(
                name: "file.pdf",
                size: Size(),
                type: .other
            )
        ]
    }
}
