//
//  CoreWrapperSwift.swift
//  CloudOnMobile
//
//

import Foundation

@_cdecl("coreDidDownlodFile") func coreDidDownlodFile(filepath: UnsafePointer<UInt8>) {
    /// - TODO: Create a structure and inject CommandManager instead of using singleton.
//    let filepathStr = String(cString: filepath)
//    CommandManager.delegate?.serverOnFileDownlaoded(filepath: filepathStr)
}

func initSharedCore() {
    set_shared_core_callbacks()
}

