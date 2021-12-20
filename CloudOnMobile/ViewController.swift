//
//  ViewController.swift
//  CloudOnMobile
//
//  Created by Cloud On Mobile Team on 18/12/2020.
//

import UIKit

final class ViewController: UIViewController, CommandManagerDelegate {
    @IBOutlet var viewSettings: UIView!
    @IBOutlet var labelCodeValue: UILabel!
    @IBOutlet var imageLock: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var switchServerTarget: UISwitch!

    var files = [CommandManager.File]()

    @IBAction func buttonSettingsClicked(_ sender: UIButton) {
        viewSettings.isHidden = !viewSettings.isHidden
    }

    @IBAction func buttonConnectClicked(_ sender: UIButton) {
        CommandManager.shared.ip = getServerUrl()
        switchServerTarget.isEnabled = false
        CommandManager.shared.connect()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as? FileTVCell else {
//            fatalError("Unable to dequeue ReminderCell")
//        }
//        let index = indexPath.row
//        cell.labelTitle.text = files[index].filename
//        return cell
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CommandManager.shared.delegate = self
        CommandManager.shared.copyDemoFiles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAllFiles()
    }

    func serverOnConnected(passocde: Int) {
        DispatchQueue.main.async {
            self.labelCodeValue.text = "\(passocde)"
            UIApplication.shared.isIdleTimerDisabled = true
            self.imageLock.image = UIImage(named: "accessCodeUnlocked")
        }
    }

    func serverOnClose() {
        DispatchQueue.main.async {
            self.labelCodeValue.text = "serverOnClose"
        }
    }

    func serverOnReconnecting() {
        print("reconnecting")
    }

    func serverOnReconnected() {
        DispatchQueue.main.async {
            self.labelCodeValue.text = "serverOnReconnected"
        }
    }

    func serverOnFileDownlaoded(filepath: String) {
        print("serverOnFileDownlaoded: " + filepath)
        DispatchQueue.main.async {
            self.fetchAllFiles()
            self.tableView.reloadData()
        }
    }

    func getServerUrl() -> String {
        if switchServerTarget.isOn {
            return "cloudon.cc"
        } else {
            return "192.168.50.10"
        }
    }

    func serverOnNewMessage(data: Data) {
        DispatchQueue.main.async {
            self.labelCodeValue.text = String(data: data, encoding: .ascii)
        }
    }

    func fetchAllFiles() {
        files = (CommandManager.shared.listFiles() ?? []).filter { file in
            // TODO: Use isDir instead of comparing strings
            file.filename != "." && file.filename != ".."
        }
    }
}
