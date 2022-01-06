//
//  File.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

struct File: Codable {
    /// Name of the file.
    let name: String

    /// Size of the file in bytes
    let size: Int

    /// Prettified size of a file.
    var sizeTranslation: String {
        var sizeTmp = Double(size)
        let units = ["B", "KB", "MB", "GB", "TB"]
        var unitIndex = 0
        while sizeTmp > 1024 {
            unitIndex += 1
            sizeTmp /= 1024
        }
        if unitIndex >= 0, unitIndex < units.count {
            return "\(Int(sizeTmp.rounded())) \(units[unitIndex])"
        } else {
            return "\(size) B"
        }
    }

    /// Type of the file.
    var type: FileType {
        let fileExtension = URL(fileURLWithPath: name).pathExtension.lowercased()
        return FileType.allCases.first(where: {
          $0.pathExtension.first(where:
              {$0 == fileExtension}
          ) != nil }) ?? .other
      }
}
