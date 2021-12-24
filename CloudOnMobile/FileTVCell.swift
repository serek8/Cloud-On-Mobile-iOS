//
//  FileTVCell.swift
//  CloudOnMobile
//
//  Created by Jan Seredynski on 12/12/2021.
//

import UIKit

let KB = 1024
let MB = KB*1024
let GB = MB*1024

class FileTVCell: UITableViewCell {

  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var labelSize: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setSize(size: Int) {
    if(size < KB){
      labelSize.text = "\(size) B"
    }
    else if(size < MB){
      labelSize.text = "\(size/KB) KB"
    }
    else if(size < GB){
      labelSize.text = "\(size/MB) MB"
    }
  }

}
