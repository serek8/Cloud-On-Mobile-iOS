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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAndSetContentFromContext()
    }
}

// MARK: - Private

private extension ShareViewController {
    func fetchAndSetContentFromContext() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        extensionItems.forEach { extensionItem in
            guard let itemProviders = extensionItem.attachments else {
                return
            }
            for itemProvider in itemProviders {
                if itemProvider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                    itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.data.identifier) { url, error in
                        if let url = url {
                            self.saveFile(url)
                        } else {
                            if error != nil {
                                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.data.identifier) { data, _ in
                                    if let data = data {
                                        self.saveData(data, type: UTType.data)
                                    }
                                }
                            }
                        }
                        self.finishImport()
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { item, _ in
                        if let url = item as? URL {
                            if let data = url.absoluteString.data(using: .utf8) {
                                self.saveData(data, type: UTType.url)
                            }
                        }
                        self.finishImport()
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                    itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier) { item, _ in
                        if let item = item as? String {
                            if let data = item.data(using: .utf8) {
                                self.saveData(data, type: UTType.text)
                            }
                        }
                        self.finishImport()
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier) { item, _ in
                        if let item = item as? UIImage {
                            if let pngData = item.pngData() {
                                self.saveData(pngData, type: UTType.image)
                            }
                        } else {
                            if let url = item as? URL {
                                self.saveFile(url)
                            }
                        }
                        self.finishImport()
                    }
                } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
                    itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.data.identifier) { url, error in
                        if let url = url {
                            self.saveFile(url)
                        } else {
                            if error != nil {
                                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.data.identifier) { data, _ in
                                    if let data = data {
                                        self.saveData(data, type: UTType.data)
                                    }
                                }
                            }
                        }
                        self.finishImport()
                    }
                } else {
                    finishImport()
                }
            }
        }
    }

    func finishImport() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: "cloudon://import") else { return }
            _ = self.openURL(url)
        })
    }

    func saveFile(_ url: URL) {
        if let data = try? Data(contentsOf: url) {
            if let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon") {
                let docDir = sharedDirectory.appendingPathComponent("Documents")
                if FileManager.default.fileExists(atPath: docDir.path) == false {
                    try? FileManager.default.createDirectory(atPath: docDir.path, withIntermediateDirectories: true, attributes: nil)
                }
                let urlImprotedFile = docDir.appendingPathComponent(url.lastPathComponent)
                try? data.write(to: urlImprotedFile)
            }
        }
    }

    func saveData(_ data: Data, type: UTType?) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd-HH-mm-ss"
        var filename = "\(dateFormatter.string(from: date))"
        if let type = type {
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
        } else {
            filename = "file-" + filename
        }

        if let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon") {
            let docDir = sharedDirectory.appendingPathComponent("Documents")
            if FileManager.default.fileExists(atPath: docDir.path) == false {
                try? FileManager.default.createDirectory(atPath: docDir.path, withIntermediateDirectories: true, attributes: nil)
            }
            let urlImprotedFile = docDir.appendingPathComponent(filename)
            try? data.write(to: urlImprotedFile)
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
