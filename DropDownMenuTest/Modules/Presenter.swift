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
        return ["tsdfag1", "tagfewrwert2", "tag3", "kdhjfgkhd;gk", "xfghs;fj"]
    }
    
    func configureDetailCell(_ cell: DropDownMenuTableViewCell) {
        cell.cellInit(tags: getTags())
    }
}
