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

func listFiles() -> Data? {
    let data_out_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
    let len = list_dir_locally(UnsafePointer<CChar>?.none, data_out_ptr)
    if len <= 0 {
        return nil
    }
    let data = Data(bytesNoCopy: data_out_ptr.pointee!, count: Int(len), deallocator: Data.Deallocator.free)
    data_out_ptr.deallocate()
    return data
}
