//
//  ViewController.swift
//  CloudOnMobile
//
//  Created by Cloud On Mobile Team on 18/12/2020.
//

import UIKit

final class ViewController: UIViewController, CommandManagerDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var imageLock: UIImageView!
  var files = [CommandManager.File]()

  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return files.count
  }
  
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as? FileTVCell else {
        fatalError("Unable to dequeue ReminderCell")
    }
    let index = indexPath.row
    cell.labelTitle.text = files[index].filename
    return cell
  }
  

  @IBOutlet weak var tableView: UITableView!
  
  
    func serverOnReconnecting() {
        print("reconnecting")
    }

    @IBOutlet var switchServerTarget: UISwitch!
    func serverOnClose() {
        DispatchQueue.main.async {
            self.labelCodeValue.text = "serverOnClose"
        }
    }

    func getServerUrl() -> String {
        if switchServerTarget.isOn {
            return "cloudon.cc"
        } else {
            return "192.168.50.10"
        }
    }

    func serverOnConnected(passocde: Int) {
        DispatchQueue.main.async {
            self.labelCodeValue.text = "\(passocde)"
            UIApplication.shared.isIdleTimerDisabled = true
          self.imageLock.image = UIImage.init(named: "accessCodeUnlocked")
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

    func serverOnClose(status: Int) {}
  
  

  @IBAction func buttonSettingsClicked(_ sender: UIButton) {
    viewSettings.isHidden = !viewSettings.isHidden
    
  }
  
  @IBOutlet weak var viewSettings: UIView!
  @IBOutlet var labelCodeValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//      tlsHanshake()
      
        CommandManager.shared.delegate = self
      CommandManager.shared.copyDemoFiles()
        // Do any additional setup after loading the view.

//        CommandManager.shared.listFiles()
    }
  
//  override func viewDidAppear(_ animated: Bool) {
////    CommandManager.shared.listFiles()
//  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    files = (CommandManager.shared.listFiles() ?? []).filter({ file in
      file.filename != "." && file.filename != ".."
    })
  }
  
    @IBAction func buttonConnectClicked(_ sender: UIButton) {
        CommandManager.shared.ip = getServerUrl()
        switchServerTarget.isEnabled = false
        CommandManager.shared.connect()
    }
}
