//
//  Presenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import Foundation

protocol PresenterProtocol {
    init(view: ViewController)
    func getTags() -> [String]
    func configureDetailCell(_ cell: DropDownMenuTableViewCell)
}

class Presenter: PresenterProtocol {
    private weak var view: ViewController?
    
    var currentTags: [String] = []
    
    required init(view: ViewController) {
        self.view = view
    }
    
    func getTags() -> [String] {
        return ["tag1", "tag2", "tag3"]
    }
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        cell.cellInit(tags: currentTags)
    }
}
