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