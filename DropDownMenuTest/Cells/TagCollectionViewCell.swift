//
//  TagCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func cellInit(title: String) {
        tagButton.setTitle(title, for: .normal)
    }

    @IBAction func tagButtonAction(_ sender: UIButton) {
        // batton handler to delete cell from collectionView
    }
}
