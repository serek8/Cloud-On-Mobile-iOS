//
//  Size.swift
//  CloudOnMobile
//
//  Created by Karol P on 06/01/2022.
//

import Foundation

struct Size {
    private var byteCountFormatter: ByteCountFormatter {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.countStyle = .file
        return byteCountFormatter
    }

    private let numberOfBytes: Int64

    /// Initialize Size structure.
    /// - Parameters:
    ///   - numberOfBytes: size in bytes.
    init(
        numberOfBytes: Int64
    ) {
        self.numberOfBytes = numberOfBytes
    }

    /// Translation of the size.
    var translation: String {
        byteCountFormatter.string(fromByteCount: numberOfBytes)
    }
}
