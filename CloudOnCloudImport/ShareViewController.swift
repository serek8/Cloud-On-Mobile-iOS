//
//  ShareViewController.swift
//  CloudOnCloudImport
//
//  Created by Jan Seredynski on 06/11/2022.
//

import MobileCoreServices
import Social
import UIKit
import UniformTypeIdentifiers

final class ShareViewController: UIViewController {
    private lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    var remainingAttachementsCount = 0
    let lock = UnfairLock()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.saveExtensionItems()
        }
    }
}

// MARK: - Private views

private extension ShareViewController {
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
    }
}

// MARK: - Private saving data

private extension ShareViewController {
    func saveExtensionItems() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }
        remainingAttachementsCount = 0
        extensionItems.forEach { extensionItem in
            guard let itemProviders = extensionItem.attachments else {
                return
            }
            remainingAttachementsCount += extensionItems.count
            itemProviders.forEach { itemProvider in
                save(itemProvider: itemProvider)
            }
        }
    }

    func save(itemProvider: NSItemProvider) {
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            saveData(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            saveUrl(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
            saveText(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
            saveImage(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
            saveData(itemProvider: itemProvider)
        } else {
            openMainAppIfFinished()
        }
    }

    func saveData(itemProvider: NSItemProvider) {
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.data.identifier) { [weak self] url, error in
            guard error == nil else {
                self?.openMainAppIfFinished()
                return
            }

            if let url {
                self?.saveFile(url: url)
            }
            self?.openMainAppIfFinished()
        }
    }

    func saveUrl(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.openMainAppIfFinished()
                return
            }
            if let url = item as? URL, let data = url.absoluteString.data(using: .utf8) {
                self?.saveData(data, type: UTType.url)
            }
            self?.openMainAppIfFinished()
        }
    }

    func saveText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.openMainAppIfFinished()
                return
            }
            if let item = item as? String, let data = item.data(using: .utf8) {
                self?.saveData(data, type: UTType.text)
            }
            self?.openMainAppIfFinished()
        }
    }

    func saveImage(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.openMainAppIfFinished()
                return
            }
            if let itemUrl = item as? URL {
                self?.saveFile(url: itemUrl)
            } else {
                if let item = item as? UIImage, let pngData = item.pngData() {
                    self?.saveData(pngData, type: UTType.image)
                } else if let url = item as? URL, let data = try? Data(contentsOf: url) {
                    self?.saveData(data, type: .image)
                }
            }
            self?.openMainAppIfFinished()
        }
    }

    func saveFile(url: URL) {
        guard let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon") else {
            return
        }
        let docDir = sharedDirectory.appendingPathComponent("Documents")
        createDocumentsDirectoryIfNeeded(docDir)
        try? FileManager.default.copyItem(at: url, to: docDir.appendingPathComponent(url.lastPathComponent))
    }

    func saveData(_ data: Data, type: UTType) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd-HH-mm-ss"
        var filename = "\(dateFormatter.string(from: date))"

        switch type {
        case .image:
            filename = "image-" + filename + ".png"
        case .text:
            filename = "image-" + filename + ".txt"
        case .url:
            filename = "url-" + filename + ".txt"
        default:
            filename = "file-" + filename
        }

        guard let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon") else {
            return
        }

        let docDir = sharedDirectory.appendingPathComponent("Documents")
        createDocumentsDirectoryIfNeeded(docDir)
        var urlImprotedFile = docDir.appendingPathComponent(filename)
        urlImprotedFile = renameFileIfDuplicated(urlImprotedFile)
        try? data.write(to: urlImprotedFile)
    }

    func renameFileIfDuplicated(_ urlImprotedFile: URL) -> URL {
        if FileManager.default.fileExists(atPath: urlImprotedFile.absoluteString) {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "SSSS"
            return renameFileIfDuplicated(urlImprotedFile.appendingPathExtension("_\(dateFormatter.string(from: date))"))
        }
        return urlImprotedFile
    }

    func createDocumentsDirectoryIfNeeded(_ docDir: URL) {
        if FileManager.default.fileExists(atPath: docDir.path) == false {
            try? FileManager.default.createDirectory(atPath: docDir.path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func openMainAppIfFinished() {
        lock.locked {
            self.remainingAttachementsCount -= 1
            if remainingAttachementsCount != 0 {
                return
            }
            extensionContext?.completeRequest(returningItems: nil, completionHandler: { [weak self] _ in
                guard let url = URL(string: "cloudon://import") else { return }
                _ = self?.openURL(url)
            })
        }
    }

    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
