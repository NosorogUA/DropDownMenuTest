//
//  DropOptionTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class DropOptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    func setupCell(title: String){
        titleLabel.text = title
    }
}
