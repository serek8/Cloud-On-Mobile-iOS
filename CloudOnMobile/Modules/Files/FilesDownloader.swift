//
//  FilesDownloader.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

struct DefaultFilesDownloader: FilesDownloader {
  
  let dataProvider : DataProvider
  
  init(dataProvided:DataProvider) {
    self.dataProvider = dataProvided
  }
  
  func getFilesList() async -> [File] {
    guard let data = self.dataProvider.listFiles() else { return [] }
      let decoder = JSONDecoder()
      let files = try? decoder.decode([File].self, from: data)
      return files ?? []
  }
}
