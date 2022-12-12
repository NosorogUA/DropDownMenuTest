//
//  SearchBarCollectionViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class SearchBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var searchBarTextField: UITextField!
    
    @IBOutlet weak var widhtConstraint: NSLayoutConstraint!
    
    var startSearch: (() -> Void)?
    var endSearch: (() -> Void)?
    var filterResults: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBarTextField.delegate = self
        
    }
    func stopResize() {
        guard let text = searchBarTextField.text else {
            widhtConstraint.constant = 80
            return }
        let font = searchBarTextField.font
        var size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font: font] )
        print(size.width)
        if size.width > 150 {
            widhtConstraint.constant = size.width
        }
    }
    
    func getEnters() -> String {
        return searchBarTextField.text ?? " "
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
        filterResults?()
        ()
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
