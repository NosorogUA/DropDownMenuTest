//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropView)
    
}

class DropViewPresenter: DropViewPresenterProtocol {
    
    private weak var view: DropView?
    
    var currentTags: [String] = []
    
    required init(view: DropView) {
        self.view = view
    }
    
    func applyTag(tag: String) {
        currentTags.append(tag)
        // reload collection view
    }
    
    func deleteTag(tag: String) {
        currentTags = currentTags.filter {$0 != tag}
        // reload collection view
    }
    
    func getTags() -> [String] {
        return ["tag1", "tag2", "tag3"]
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getTags()
        print(titles)
        cell.setupCell(title: titles[indexPath.row])
    }
}
