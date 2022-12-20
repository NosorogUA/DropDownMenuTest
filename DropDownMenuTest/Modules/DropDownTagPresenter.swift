//
//  DropDownTagPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol DropDownTagPresenterProtocol {
    init(view: DropDownTagViewControllerProtocol)
    func getTitle(index: Int) -> String
    func getCurrentTags() -> [String]
    func getCustomTags() -> [String]
    func getUsedTags() -> [String]
    func getCurrentTags2() -> [String]
    func getCustomTags2() -> [String]
    func getUsedTags2() -> [String]
    func saveTags(custom: [String], selected: [String])
    
}

class DropDownTagPresenter: DropDownTagPresenterProtocol {
    private weak var view: DropDownTagViewControllerProtocol?
    
    var currentTags: [String] = ["tag1", "tag2", "tag3", "apple", "google", "facebook"]
    var customUserTags: [String] = ["custom1"]
    var currentTags2: [String] = ["tag12", "tag22", "tag32", "apple2", "google2", "facebook2"]
    var customUserTags2: [String] = ["custom12"] 
    var alreadyUsedTags1: [String] = ["tag3"]
    var alreadyUsedTags2: [String] = ["tag32"]
    
    var filteredTags: [String] = []
    var filteredTags2: [String] = []
    
    var finishCustomTags: [String] = []
    var finishAlreadySelectedTags: [String] = []
    
    var title: [String] = ["title", "title2", "title3"]
    
//    private let isCustomTagsEnabled = true //tags customization option change here
//    private let isCustomTagsEnabled2 = false
//
    required init(view: DropDownTagViewControllerProtocol) {
        self.view = view
        // apply current tags here
    }
    
    func getTitle(index: Int) -> String  {
        return title[index]
    }

    func getCurrentTags() -> [String] {
            return currentTags
    }
    
    func getCustomTags() -> [String] {
            return customUserTags
    }
    
    func getUsedTags() -> [String] {
            return alreadyUsedTags1
    }
    
    func getCurrentTags2() -> [String] {
            return currentTags2
    }
    
    func getCustomTags2() -> [String] {
            return customUserTags2
    }
    
    func getUsedTags2() -> [String] {
            return alreadyUsedTags2
    }
    
    func saveTags(custom: [String], selected: [String]) {
        finishCustomTags = custom
        finishAlreadySelectedTags = selected
    }

}
