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
    func addCustomTag(tag: String) 
    func removeCustomTag(tag: String)
}

class DropDownTagPresenter: DropDownTagPresenterProtocol {
    private weak var view: DropDownTagViewControllerProtocol?
    
    var currentTags: [String] = ["tag1", "tag2", "tag3", "apple", "google", "facebook"]
    var customUserTags: [String] = ["custom1"] {
        didSet {
            print(customUserTags)
        }
    }
    var filteredTags: [String] = []
    
    private let isCustomTagsEnabled = true //tags customization option change here
    
    required init(view: DropDownTagViewControllerProtocol) {
        self.view = view
        // apply current tags here
    }
    
    func configureFilteredTag(tag: String) {
        if filteredTags.contains(tag) {
            filteredTags = filteredTags.filter {$0 != tag}
        } else {
            filteredTags.append(tag)
        }
        view?.updateTableViewLayouts()
    }
    
    func add(tag: String) {
        if currentTags.contains(tag) {
            if filteredTags.contains(tag) {
                return
            } else {
                filteredTags.append(tag)
            }
            view?.updateTableViewLayouts()
        } else {
            addCustomTag(tag: tag)
        }
    }
    
    func remove(tag: String) {
        if currentTags.contains(tag) {
            if filteredTags.contains(tag) {
                filteredTags = filteredTags.filter {$0 != tag}
            } else {
                return
            }
            view?.updateTableViewLayouts()
        } else {
            removeCustomTag(tag: tag)
        }
    }
    
    func addCustomTag(tag: String) {
        if customUserTags.contains(tag) {
            return
        } else {
            customUserTags.append(tag)
        }
    }
    
    func removeCustomTag(tag: String) {
        if customUserTags.contains(tag) {
            customUserTags = customUserTags.filter {$0 != tag}
        } else {
            return
        }
    }
    
    func getCurrentTags() -> [String] {
        return currentTags
    }
    
    func getFilteredTags() -> [String] {
        if isCustomTagsEnabled {
            return filteredTags + customUserTags
        } else {
            return filteredTags
        }
    }
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        cell.cellInit(tags: getFilteredTags(), enableCustomTags: isCustomTagsEnabled)
    }
}
