//
//  DropOptionTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class DropOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("====Drop option cell init")
        // Initialization code
    }
    
    func setupCell(title: String){
        titleLabel.text = title
    }
}
