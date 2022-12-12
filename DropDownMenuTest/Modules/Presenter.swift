//
//  Presenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol PresenterProtocol {
    init(view: ViewController)
    func getCurrentTags() -> [String]
    func configureDetailCell(_ cell: DropDownMenuTableViewCell)
    func configureFilteredTag(tag: String)
}

class Presenter: PresenterProtocol {
    private weak var view: ViewController?
    
    var currentTags: [String] = ["tsdfag1", "tagfewrwert2", "tag3", "kdhjfgkhd;gk", "xfghs;fj"]
    var filteredTags: [String] = []
    
    required init(view: ViewController) {
        self.view = view
        // apply current tags here
    }
    
    func configureFilteredTag(tag: String) {
        if filteredTags.contains(tag) {
            filteredTags = filteredTags.filter {$0 != tag}
            print("Tag filtered: \(tag), deleted")
        } else {
            filteredTags.append(tag)
            print("Tag filtered: \(tag), added")
        }
        view?.reloadData()
    }
    
    func getCurrentTags() -> [String] {
        return currentTags
    }
    
    func getFilteredTags() -> [String] {
        return filteredTags
    }
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        print(getFilteredTags())
        cell.cellInit(tags: getFilteredTags())
    }
}
