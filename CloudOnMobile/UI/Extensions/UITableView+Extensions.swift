//
//  UITableView+Extensions.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

extension UITableView {
    /// Returns a dequeued cell with specific cell type.
    /// If CellType has not been registered before it will register it.
    /// - Parameters:
    ///   - cellType: Type of cell to dequeue.
    func getReusableCellSafe<CellType: UITableViewCell>(cellType: CellType.Type) -> CellType {
        if let cell = dequeueReusableCell(withIdentifier: cellType.className) as? CellType {
            return cell
        } else {
            register(cellType, forCellReuseIdentifier: cellType.className)
            return dequeueReusableCell(withIdentifier: cellType.className) as! CellType
        }
    }
}
