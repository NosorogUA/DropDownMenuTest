//
//  DropDownTagPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol DropDownTagPresenterProtocol {
    init(view: DropDownTagViewControllerProtocol)
    func getCurrentTags() -> [String]
    func configureDetailCell(_ cell: DropDownMenuTableViewCell)
    func add(tag: String)
    func remove(tag: String)
}

class DropDownTagPresenter: DropDownTagPresenterProtocol {
    private weak var view: DropDownTagViewControllerProtocol?
    
    var currentTags: [String] = ["tag1", "tag2", "tag3", "apple", "google", "facebook"]
    var filteredTags: [String] = []
    
    required init(view: DropDownTagViewControllerProtocol) {
        self.view = view
        // apply current tags here
    }
    
    func configureFilteredTag(tag: String) {
        if filteredTags.contains(tag) {
            filteredTags = filteredTags.filter {$0 != tag}
            //print("Tag filtered: \(tag), deleted")
        } else {
            filteredTags.append(tag)
            //print("Tag filtered: \(tag), added")
        }
        view?.updateTableViewLayouts()
    }
    
    func add(tag: String) {
        if filteredTags.contains(tag) {
            return
        } else {
            filteredTags.append(tag)
            //print("Tag filtered: \(tag), added")
        }
        view?.updateTableViewLayouts()
    }
     
    func remove(tag: String) {
        if filteredTags.contains(tag) {
            filteredTags = filteredTags.filter {$0 != tag}
            //print("Tag filtered: \(tag), deleted")
        } else {
            return
        }
        view?.updateTableViewLayouts()
    }
    
    func getCurrentTags() -> [String] {
        return currentTags
    }
    
    func getFilteredTags() -> [String] {
        return filteredTags
    }
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        cell.cellInit(tags: getFilteredTags())
    }
}
