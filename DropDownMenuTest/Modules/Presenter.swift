//
//  Presenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol PresenterProtocol {
    init(view: ViewController)
    func configureDetailCell(_ cell: DropDownMenuTableViewCell)
    func getTags()-> [String]
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath)
}

class Presenter: PresenterProtocol {
    private weak var view: ViewController?
    
    var currentTags: [String] = []
    
    required init(view: ViewController) {
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
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        cell.cellInit(tags: currentTags)
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getTags()
        print(titles)
        cell.setupCell(title: titles[indexPath.row])
    }
}
