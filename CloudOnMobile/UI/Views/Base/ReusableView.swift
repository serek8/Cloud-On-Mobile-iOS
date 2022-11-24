//
//  ReusableView.swift
//  CloudOnMobile
//
//  Created by Karol P on 26/12/2021.
//

import UIKit

protocol ReusableView: AnyObject {
    /// Reusable identifier used to register view in TableView or CollectionView.
    static var reusableIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reusableIdentifier: String { String(describing: self) }
}
