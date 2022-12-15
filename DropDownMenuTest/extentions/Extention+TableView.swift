//
//  Extention+TableView.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
