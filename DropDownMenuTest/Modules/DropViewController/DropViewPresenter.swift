//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropView)
    func applyTag(tag: String)
    
}

class DropViewPresenter: DropViewPresenterProtocol {
    
    private weak var view: DropView?
    
    var currentTags: [String] = []
    
    required init(view: DropView) {
        self.view = view
    }
    
    func applyTag(tag: String) {
        
        if currentTags.contains(tag) {
            currentTags = currentTags.filter {$0 != tag}
            print("Tag: \(tag), deleted")
        } else {
            currentTags.append(tag)
            print("Tag: \(tag), added")
        }
        // reload collection view
    }
    
    func getTags() -> [String] {
        return ["tag1", "tag2", "tag3"]
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getTags()
        cell.setupCell(title: titles[indexPath.row])
    }
}
