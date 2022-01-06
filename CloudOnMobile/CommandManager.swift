//
//  CommandManager.swift
//  CloudOnMobile
//
//  Created by Cloud On Mobile Team on 21/11/2021.
//

import UIKit

protocol CommandManagerDelegate: AnyObject {
    func serverOnClose()
    func serverOnConnected(passocde: Int)
    func serverOnReconnecting()
    func serverOnReconnected()
    func serverOnFileDownlaoded(filepath: String)
}

protocol DataProvider {
  func listFiles() -> Data?
}

final class CommandManager : DataProvider {
    enum CommandManagerError: Error {
        case connectionFailure
    }

    struct File: Codable {
        /// Name of the file.
        let fileName: String?
    }

    struct Request<T: Codable>: Codable {
        var type: String?
        var command: String?
        var payload: T?
    }

    weak var delegate: CommandManagerDelegate?

    private var code: UInt32 = 0

    private var isConnected = false

    private let ip: String

    private let port: Int = 9293

    private let documentsDirectory: URL

    init(url: String) {
        ip = url
        initSharedCore()
        let fileMngr = FileManager.default
        documentsDirectory = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        setup_environment(documentsDirectory.path)
        copyDemoFiles()
    }

    func connect() async throws -> Int {
        try await withUnsafeThrowingContinuation { continuation in
            self.ip.withCString { (ip_cstr: UnsafePointer<Int8>) in
                let code = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
                guard connect_to_server(ip_cstr, Int32(self.port), code) == 0 else {
                    self.isConnected = false
                    continuation.resume(throwing: CommandManagerError.connectionFailure)
                    return
                }
                self.isConnected = true
                let value = Int(code.pointee)
                continuation.resume(returning: value)
                code.deallocate()
                Thread.detachNewThread {
                    _ = self.endlessListen()
                }
            }
        }
    }

    func reconnectIfNeeded() {
        UIApplication.shared.isIdleTimerDisabled = true
        if should_reconnect() == 0 {
            return
        }
        Thread.detachNewThread {
            self.ip.withCString { (_: UnsafePointer<Int8>) in
                let code = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
                if reconnect_to_server(self.code) != 0 {
                    self.isConnected = false
                    self.delegate?.serverOnClose()
                    return
                } else {
                    self.isConnected = true
                    self.delegate?.serverOnReconnected()
                }
                code.deallocate()
                _ = self.endlessListen()
            }
        }
    }

    func endlessListen() -> Int {
        let retval = runEndlessServer()
        if retval == -1 {
            isConnected = false
            return -1
        }
        return Int(retval)
    }

    func copyDemoFiles() {
        let hasLaunchedKey = "HasAddedDemoFiles"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            let sampleImage = UIImage(named: "sample_image.jpeg")
            let sampleImagePath = documentsDirectory.appendingPathComponent("Sample Image.png")
            try? sampleImage?.pngData()?.write(to: sampleImagePath)
        }
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

}
