//
//  TagCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var background: UIImageView!
    @IBOutlet private weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
    private func setupLabel() {
        background.layer.cornerRadius = 10
        background.clipsToBounds = true
    }
    
    func cellInit(title: String) {
        tagLabel.text = title
//        if title.count > 30 {
//            tagLabel.numberOfLines = 2
//        } else {
//            tagLabel.numberOfLines = 1
//        }
    }
    
}
