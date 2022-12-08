//
//  DropOptionTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class DropOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UISwitch!
    
    var addHandler: (()-> Void)?
    var removeHandler: (()-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(title: String){
        titleLabel.text = title
        checkBox.isOn = false
    }
    
    func invertSelection() {
        checkBox.isOn = !checkBox.isOn
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        invertSelection()
        // add / remove tag in list
        if !checkBox.isOn {
            //add tag
            addHandler?()
        } else {
            //remove tag
            removeHandler?()
        }
    }
    
}
