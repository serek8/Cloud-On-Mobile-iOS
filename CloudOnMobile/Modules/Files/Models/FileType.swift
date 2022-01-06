//
//  FileType.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

enum FileType : CaseIterable {
    case image
    case music
    case video
    case other
}

extension FileType {
    var pathExtension: [String] {
        switch self {
        case .image: return ["png", "jpg", "jpeg", "gif"]
        case .music: return ["mp3", "wav3"]
        case .video: return ["mp4", "mov"]
        case .other: return []
        }
    }

    var image: UIImage {
        switch self {
        case .image:
            return UIImage(imageLiteralResourceName: "image")
        case .music:
            return UIImage(imageLiteralResourceName: "music")
        case .video:
            return UIImage(imageLiteralResourceName: "video")
        case .other:
            return UIImage(imageLiteralResourceName: "file")
        }
    }
}
