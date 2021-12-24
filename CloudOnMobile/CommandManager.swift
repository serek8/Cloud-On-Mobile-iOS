//
//  CommandManager.swift
//  CloudOnMobile
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
    func serverOnFileDownlaoded(filepath:String)
}

final class CommandManager {
    static let shared = CommandManager()
    var delegate: CommandManagerDelegate?
    var ip: String = ""
    var port: Int = 9293
    //  var port:Int = 443
    var code: UInt32 = 0
    let documentsDirectory: URL
    var isConnected = false
  
  
  struct File : Codable {
    let filename : String?
    let size : Int
  }

    init() {
        initSharedCore()
        let fileMngr = FileManager.default
        documentsDirectory = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0]
        setup_environment(documentsDirectory.path)
    }

    struct Request<T: Codable>: Codable {
        var type: String?
        var command: String?
        var payload: T?
    }

    func connect() {
        Thread.detachNewThread {
            self.ip.withCString { (ip_cstr: UnsafePointer<Int8>) in
                print("Start tcp-client thread")
                let code = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
                if connect_to_server(ip_cstr, Int32(self.port), code) != 0 {
                    self.isConnected = false
                    self.delegate?.serverOnClose() // TODO: connection failure
                    return
                }
                self.isConnected = true
                self.delegate?.serverOnConnected(passocde: Int(code.pointee))
                code.deallocate()
              _ = self.endlessListen()
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

    let samplePdfData = NSDataAsset.init(name: "sample-pdf")!.data
    let samplePdfPath = documentsDirectory.appendingPathComponent("Sample Document.pdf")
    try? samplePdfData.write(to: samplePdfPath)
    }

    func listFiles() -> [File]? {
//      let data_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
      let data_out_ptr = UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>.allocate(capacity: 1)
      let len = list_dir_locally(UnsafePointer<CChar>?.none, data_out_ptr);
      if(len <= 0){
        return nil
      }
      let decoder = JSONDecoder()
      let data = Data(bytesNoCopy: data_out_ptr.pointee!, count: Int(len), deallocator: Data.Deallocator.free)
      data_out_ptr.deallocate()
      let request = try! decoder.decode([File].self, from: data)
      return request;
    }
}
