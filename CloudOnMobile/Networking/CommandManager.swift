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

/// Protocol responsible for fetching files from backend.
protocol FilesDataProvider {
    ///  Downloads JSON data containing an array of all files stored locally.
    func listFiles() -> Result<[BackendFile], CommandManager.CommandManagerError>
}

final class CommandManager {
    enum CommandManagerError: Error {
        case connectionFailure
        case decodingError
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

    private let port: Int

    private let documentsDirectory: URL

    init(url: String, port: Int) {
        ip = url
        self.port = port
        initSharedCore()
        let fileMngr = FileManager.default
        documentsDirectory = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        setup_environment(documentsDirectory.path)
        copyDemoFiles()
    }

    /// - TODO: Add protocol for functions below.

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
            let sampleImage = UIImage(named: "AppIcon-production.png") ?? UIImage(named: "AppIcon-development.png")
            let sampleImagePath = documentsDirectory.appendingPathComponent("Sample image.png")
            try? sampleImage?.pngData()?.write(to: sampleImagePath)
        }
    }
}

// MARK: FilesDataProvider

extension CommandManager: FilesDataProvider {
    func copyFilesFromExtension() {
        if let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon") {
            let sharedDocDir = sharedDirectory.appendingPathComponent("Documents")
            if FileManager.default.fileExists(atPath: sharedDocDir.path) == false {
                try? FileManager.default.createDirectory(atPath: sharedDocDir.path, withIntermediateDirectories: true, attributes: nil)
            }

            let urls = try? FileManager.default.contentsOfDirectory(at: sharedDocDir, includingPropertiesForKeys: nil)
            if let urls = urls {
                let localDocDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                for url in urls {
                    try? FileManager.default.moveItem(at: url, to: localDocDir.appendingPathComponent(url.lastPathComponent))
                }
            }
        }
    }

    func listFiles() -> Result<[BackendFile], CommandManagerError> {
        copyFilesFromExtension()
        let data_out_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        let len = list_dir_locally(UnsafePointer<CChar>?.none, data_out_ptr)

        guard len > 0 else {
            return .success([])
        }

        let data = Data(bytesNoCopy: data_out_ptr.pointee!, count: Int(len), deallocator: Data.Deallocator.free)
        data_out_ptr.deallocate()

        return decode(data: data, responseType: [BackendFile].self)
    }
}

// MARK: - Private

private extension CommandManager {
    func decode<T>(data: Data, responseType: T.Type) -> Result<T, CommandManagerError> where T: Decodable {
        let decoder = JSONDecoder()
        do {
            let files = try decoder.decode(responseType, from: data)
            return .success(files)
        } catch {
            return .failure(.decodingError)
        }
    }
}
