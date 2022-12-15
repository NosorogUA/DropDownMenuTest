//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropViewProtocol)
    func add(tag: String)
    func remove(tag: String)
    func filterTags(mask: String)
    func getTags() -> [String]
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath)
}

class DropViewPresenter: DropViewPresenterProtocol {
    
    private weak var view: DropViewProtocol?
    
    var currentTags: [String] = []
    var filteredTags: [String] = []
    
    required init(view: DropViewProtocol) {
        self.view = view
    }
    
    func add(tag: String) {
        if currentTags.firstIndex(where: { $0 == tag }) != nil {
            return
        } else {
            currentTags.append(tag)
            //print("Tag: \(tag), added")
        }
        
        if filteredTags.firstIndex(where: { $0 == tag }) != nil {
            return
        } else {
            filteredTags.append(tag)
            //print("Tag: \(tag), added")
        }
    }
    
    func filterTags(mask: String) {
        if mask == "" {
            filteredTags = currentTags
        } else {
            filteredTags = currentTags.filter { $0.contains(mask) }
        }
    }
    
    func remove(tag: String) {
        if let index = currentTags.firstIndex(where: { $0 == tag }) {
            currentTags.remove(at: index)
        } else {
            return
        }
        
        if let filterIndex = filteredTags.firstIndex(where: { $0 == tag }) {
            filteredTags.remove(at: filterIndex)
            //print("Tag: \(tag), deleted")
        } else {
            return
        }
    }
    
    func getTags() -> [String] {
        return filteredTags
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getTags()
        cell.setupCell(title: titles[indexPath.row])
    }
}
