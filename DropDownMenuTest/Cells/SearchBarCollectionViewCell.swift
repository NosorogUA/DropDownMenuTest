//
//  SearchBarCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class SearchBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var searchBarTextField: UITextField!
    
    var startSearch: (() -> Void)?
    var endSearch: (() -> Void)?
    var filterResults: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBarTextField.delegate = self
        
    }
    
//    private func setupTextField() {
//        let fixedWidth = searchBarTextField.frame.size.width
//        let newSize = searchBarTextField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        searchBarTextField.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//    }
    
    @IBAction private func beginSearching(_ sender: UITextField) {
        // open dropdown windows and hide button
        startSearch?()
    }
    
    @IBAction private func changedSearching(_ sender: UITextField) {
        
    }
//
    @IBAction private func endSearching(_ sender: UITextField) {
        // close dropdown windows and show button
        endSearch?()
    }
}

extension SearchBarCollectionViewCell: UITextFieldDelegate {
    
   
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        //setupTextField()
//    }
//
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//        endSearch?()
//        return true
//    }
}
