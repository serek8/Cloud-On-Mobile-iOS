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

final class CommandManager {
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
        let sampleImage = UIImage(named: "sample-image.jpeg")
        let mexicoImgPath = documentsDirectory.appendingPathComponent("Sample Image.png")
        try? sampleImage?.pngData()?.write(to: mexicoImgPath)

        let samplePdfData = NSDataAsset(name: "sample-pdf")!.data
        let samplePdfPath = documentsDirectory.appendingPathComponent("Sample Document.pdf")
        try? samplePdfData.write(to: samplePdfPath)
    }

    func listFiles() -> [File]? {
//      let data_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        let data_out_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        let len = list_dir_locally(UnsafePointer<CChar>?.none, data_out_ptr)
        if len <= 0 {
            return nil
        }
        let decoder = JSONDecoder()
        let data = Data(bytesNoCopy: data_out_ptr.pointee!, count: Int(len), deallocator: Data.Deallocator.free)
        data_out_ptr.deallocate()
        let request = try! decoder.decode([File].self, from: data)
        return request
        ////    access("sd", F_OK)
//    setup_environment(documentsPath)
//    let mexico_path = documentsPath + "/mexico.png"
//
//    send_file(mexico_path)

//    documentsDirectory.appendingPathComponent("sample-image.png").path.utf8CString.withUnsafeBufferPointer { s in
//      send_file(s.baseAddress)
//      list_dir(s.baseAddress);
//    }

//    let fileNames = try? fileMngr.contentsOfDirectory(atPath:documentsPath)
//    var request = Request(type: "forward", command: "list-files", payload: fileNames);
//
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = .withoutEscapingSlashes
//    let data = try! encoder.encode(request)
//
//    let response = try! encoder.encode(request)
//    response.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
//      send_string_to_server(bytes)
//    }
    }

    //  func sendFile(path: String){
//    let fileMngr = FileManager.default;
//    let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//    let fileNames = try? fileMngr.contentsOfDirectory(atPath:docs)
//    let fileNames = try? fileMngr.
//    var request = Request(type: "forward", command: "list-files", payload: fileNames);
//
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = .withoutEscapingSlashes
//    let data = try! encoder.encode(request)
//
//    let response = try! encoder.encode(request)
//    response.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
//      send_string_to_server(bytes)
//    }
    //  }
//
}
