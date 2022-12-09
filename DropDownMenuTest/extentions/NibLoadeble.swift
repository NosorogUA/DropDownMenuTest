//
//  NibLoadeble.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

protocol NibLoadeble {
    
}
extension NibLoadeble where Self: UIView {
    static func fromNib<T:UIView> (_ index: Int = 0)-> T {
        let nibBundle = Bundle(for: Self.self).loadNibNamed(String(describing: self), owner: nil)
        return nibBundle![index] as! T
    }
}
