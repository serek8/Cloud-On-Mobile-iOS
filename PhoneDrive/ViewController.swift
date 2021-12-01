//
//  ViewController.swift
//  PhoneDrive
//
//  Created by Cloud On Mobile Team on 18/12/2020.
//

import UIKit

class ViewController: UIViewController, CommandManagerDelegate {
  func serverOnReconnecting() {
    print("reconnecting")
  }
  
  
  @IBOutlet weak var switchServerTarget: UISwitch!
  func serverOnClose() {
    DispatchQueue.main.async {
        self.labelCodeValue.text = "serverOnClose"
    }
  }
  
  func getServerUrl() -> String {
    if self.switchServerTarget.isOn{
      return "seredynski.com"
    }
    else{
      return "192.168.50.10"
    }
  }
  
//  func getServerUrl() -> String {
//    if self.switchServerTarget.isEnabled{
//      return "seredynski.com"
//    }
//    else{
//      return "192.168.50.10"
//    }
//  }
  
  func serverOnConnected(passocde: Int) {
    DispatchQueue.main.async {
        self.labelCodeValue.text = "\(passocde)"
        UIApplication.shared.isIdleTimerDisabled = true
    }
  }
  
  func serverOnReconnected() {
    DispatchQueue.main.async {
        self.labelCodeValue.text = "serverOnReconnected"
    }
  }
  
    
    func serverOnNewMessage(data: Data) {
        DispatchQueue.main.async {
            self.labelCodeValue.text = String(data: data, encoding: .ascii)
        }
    }
    
    func serverOnClose(status: Int) {
        
        
    }
    
    @IBOutlet weak var labelCodeValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      tlsHanshake()
      CommandManager.shared.delegate = self
        // Do any additional setup after loading the view.
      
      CommandManager.shared.listFiles()
      
    }


    @IBAction func buttonConnectClicked(_ sender: UIButton) {
      CommandManager.shared.ip = getServerUrl()
      self.switchServerTarget.isEnabled = false
      CommandManager.shared.connect()
    }
}

