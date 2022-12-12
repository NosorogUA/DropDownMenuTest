//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropView)
    func configureTag(tag: String)
    func getTags() -> [String]
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath)
}

class DropViewPresenter: DropViewPresenterProtocol {
    
    private weak var view: DropView?
    
    var currentTags: [String] = []
    
    required init(view: DropView) {
        self.view = view
    }
    
    func configureTag(tag: String) {
        if let index = currentTags.firstIndex(where: { $0 == tag }) {
            currentTags.remove(at: index)
            print("Tag: \(tag), deleted")
        } else {
            currentTags.append(tag)
            print("Tag: \(tag), added")
        }
    }
    
    func getTags() -> [String] {
        return currentTags
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getTags()
        cell.setupCell(title: titles[indexPath.row])
    }
}
