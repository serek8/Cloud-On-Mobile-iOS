//
//  CommandManager.swift
//  PhoneDrive
//
//  Created by Cloud On Mobile Team on 21/11/2021.
//

import Foundation
import UIKit

protocol CommandManagerDelegate: AnyObject {
    func serverOnClose()
    func serverOnConnected(passocde: Int)
    func serverOnReconnecting()
    func serverOnReconnected()
}

class CommandManager {
    static let shared = CommandManager()
    var delegate: CommandManagerDelegate?
    var ip: String = ""
    //  var ip:String = "seredynski.com"
    var port: Int = 9293
    //  var port:Int = 443
    var code: UInt32 = 0
    let documentsDirectory: URL
    var isConnected = false

    init() {
        let fileMngr = FileManager.default
        documentsDirectory = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        copyDemoFiles()
    }

    struct Request<T: Codable>: Codable {
        var type: String?
        var command: String?
        var payload: T?
    }

    func connect() {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        setup_environment(docs)

        Thread.detachNewThread {
            self.ip.withCString { (ip_cstr: UnsafePointer<Int8>) in
                print("Start tcp-client thread")
                let code = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
                if connect_to_server(ip_cstr, Int32(self.port), code) != 0 {
                    self.delegate?.serverOnClose() // TODO: connection failure
                    return
                }
                self.isConnected = true
                self.delegate?.serverOnConnected(passocde: Int(code.pointee))
                code.deallocate()

                // Receiving part
                self.endlessListen()
            }
        }
    }

    func reconnectIfNeeded() {
        if should_reconnect() == 0 {
            return
        }
        Thread.detachNewThread {
            self.ip.withCString { (_: UnsafePointer<Int8>) in
                print("Reconnect tcp-client thread")
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

                // Receiving part
                if self.endlessListen() == -1 {
                    self.isConnected = false
                    self.delegate?.serverOnClose()
                }
            }
        }
    }

    func endlessListen() -> Int {
        let data_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
        while true {
            if runEndlessServer() == -1 {
                isConnected = false
                return -1
            }
//        let len : Int32 = receive_string_from_server(data_ptr)
//        if(len <= 0) { break}
//        guard let raw_data = data_ptr.pointee else { break }
//
//        let data = Data(bytes: raw_data, count: Int(len))
//        self.parseRequest(requestJson: data)
//        // data will be copied so we can free imemdiately
//        free(raw_data)
//                self.serverOnNewMessage(data: data)
        }
    }

    func parseRequest(requestJson: Data) {
        let decoder = JSONDecoder()
        let request = try! decoder.decode(Request<String?>.self, from: requestJson)

        switch request.command {
        case "list-files":
            listFiles()

        default:
            print("Not the letter A")
        }
    }

    func copyDemoFiles() {
        let sampleImage = UIImage(named: "sample-image.jpeg")
        let mexicoImgPath = documentsDirectory.appendingPathComponent("sample-image.png")
        try? sampleImage?.pngData()?.write(to: mexicoImgPath)

//    let samplePdfData = NSDataAsset.init(name: "sample-pdf")!.data
//    let samplePdfPath = documentsDirectory.appendingPathComponent("Sample Document.pdf")
//    try? samplePdfData.write(to: samplePdfPath)
    }

    func listFiles() {
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
