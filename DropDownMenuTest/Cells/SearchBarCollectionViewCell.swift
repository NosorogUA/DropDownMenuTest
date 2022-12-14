//
//  SearchBarCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class SearchBarCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet private weak var searchBarTextField: UITextField!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    private var cellBounds: CGRect!
    
    var startSearch: (() -> Void)?
    var endSearch: (() -> Void)?
    var filterResults: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBarTextField.delegate = self
    }
    
    func startFiltering() {
        searchBarTextField.becomeFirstResponder()
    }
    
    func finishFiltering() {
        searchBarTextField.text = ""
        searchBarTextField.resignFirstResponder()
        searchBarTextField.endEditing(true)
    }
    
    func getStatus() -> Bool {
        return searchBarTextField.isEditing
    }
    
    func getEnters() -> String {
        return searchBarTextField.text ?? " "
    }
    
    @IBAction private func beginSearching(_ sender: UITextField) {
        // open dropdown windows and hide button
        startSearch?()
    }
    
    @IBAction private func changedSearching(_ sender: UITextField) {
        filterResults?()
    }
    
    @IBAction private func endSearching(_ sender: UITextField) {
        endSearch?()
        searchBarTextField.text = nil
    }
}

