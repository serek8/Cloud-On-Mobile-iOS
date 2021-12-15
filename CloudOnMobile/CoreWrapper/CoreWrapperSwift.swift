//
//  CoreWrapperSwift.swift
//  CloudOnMobile
//
//

import Foundation

@_cdecl("coreDidDownlodFile") func coreDidDownlodFile(filepath: UnsafePointer<UInt8>) {
    let filepathStr = String(cString: filepath)
    CommandManager.shared.delegate?.serverOnFileDownlaoded(filepath: filepathStr)
}

func initSharedCore() {
    set_shared_core_callbacks()
}
