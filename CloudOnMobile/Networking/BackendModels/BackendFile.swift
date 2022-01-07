//
//  BackendFile.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import Foundation

struct BackendFile: Codable {
    /// Name of the file.
    let name: String

    /// Size of the file in bytes.
    let size: Int64
}
