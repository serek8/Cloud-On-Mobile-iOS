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
        saveExtensionItems()
    }
}

// MARK: - Private

private extension ShareViewController {
    func saveExtensionItems() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            return
        }

        extensionItems.forEach { extensionItem in
            guard let itemProviders = extensionItem.attachments else {
                return
            }
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
            finishImport()
        }
    }

    func saveData(itemProvider: NSItemProvider) {
        itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.data.identifier) { [weak self] url, error in
            guard error == nil else {
                self?.finishImport()
                return
            }
            if let url {
                self?.saveFile(url)
            }
            self?.finishImport()
        }
    }

    func saveUrl(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.finishImport()
                return
            }
            if let url = item as? URL, let data = url.absoluteString.data(using: .utf8) {
                self?.saveData(data, type: UTType.url)
            }
            self?.finishImport()
        }
    }

    func saveText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.finishImport()
                return
            }
            if let item = item as? String, let data = item.data(using: .utf8) {
                self?.saveData(data, type: UTType.text)
            }
            self?.finishImport()
        }
    }

    func saveImage(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: UTType.image.identifier) { [weak self] item, error in
            guard error == nil else {
                self?.finishImport()
                return
            }
            if let item = item as? UIImage, let pngData = item.pngData() {
                self?.saveData(pngData, type: UTType.image)
            } else if let url = item as? URL {
                self?.saveFile(url)
            }
            self?.finishImport()
        }
    }

    func finishImport() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: { [weak self] _ in
            guard let url = URL(string: "cloudon://import") else { return }
            _ = self?.openURL(url)
        })
    }

    func saveFile(_ url: URL) {
        guard
            let data = try? Data(contentsOf: url),
            let sharedDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.cc.cloudon")
        else {
            return
        }
        let docDir = sharedDirectory.appendingPathComponent("Documents")
        if FileManager.default.fileExists(atPath: docDir.path) == false {
            try? FileManager.default.createDirectory(atPath: docDir.path, withIntermediateDirectories: true, attributes: nil)
        }
        let urlImprotedFile = docDir.appendingPathComponent(url.lastPathComponent)
        try? data.write(to: urlImprotedFile)
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
        if FileManager.default.fileExists(atPath: docDir.path) == false {
            try? FileManager.default.createDirectory(atPath: docDir.path, withIntermediateDirectories: true, attributes: nil)
        }
        let urlImprotedFile = docDir.appendingPathComponent(filename)
        try? data.write(to: urlImprotedFile)
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
