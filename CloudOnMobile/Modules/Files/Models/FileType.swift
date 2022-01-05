//
//  FileType.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

enum FileType {
    case image
    case music
    case video
    case other
}

extension FileType {
    init(filename: String) {
        let pathExtension = URL(fileURLWithPath: filename).pathExtension.lowercased()
        switch pathExtension {
        case "gif",
             "jpeg",
             "jpg",
             "png":
            self = .image
        case "mp3",
             "wav":
            self = .music
        case "mov",
             "mp4":
            self = .video
        default:
            self = .other
        }
    }
}

extension FileType {
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
