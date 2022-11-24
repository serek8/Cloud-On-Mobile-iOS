//
//  NSObject+Extensions.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import Foundation

extension NSObject {
    /// Returns class name stripped without module name.
    class var className: String {
        let namespaceClassName = String(describing: self)
        return namespaceClassName.components(separatedBy: ".").last!
    }
}
