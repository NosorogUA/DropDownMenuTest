//
//  TagCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLabel()
    }
    
    func setupLabel() {
        background.layer.cornerRadius = 10
        background.clipsToBounds = true
    }
    
    func cellInit(title: String) {
        tagLabel.text = title
    }
}
