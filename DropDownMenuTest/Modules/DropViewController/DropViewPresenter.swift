//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropViewProtocol)
    func setupStartTagList(tags: [String])
    func add(tag: String)
    func remove(tag: String)
    func filterTags(mask: String)
    func checkCurrentTags()
    func getCurrentTags() -> [String]
    func getFilteredTags() -> [String] 
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath)
}

class DropViewPresenter: DropViewPresenterProtocol {
    
    private weak var view: DropViewProtocol?
    
    var startTags: [String] = []
    var currentTags: [String] = []
    var deletedTags: [String] = []
    var filteredTags: [String] = []
    
    private var currentMask: String?
    
    required init(view: DropViewProtocol) {
        self.view = view
    }
    
    func setupStartTagList(tags: [String]) {
        for tag in tags {
            startTags.append(tag)
        }
        checkCurrentTags()
        filterTags(mask: "")
        view?.reloadData()
    }
    
    func checkCurrentTags() {
        currentTags = startTags.filter { !deletedTags.contains($0) }
        filterTags(mask: currentMask ?? "")
    }
    
    func filterTags(mask: String) {
        if mask == "" {
            filteredTags = currentTags
        } else {
            currentMask = mask
            filteredTags = currentTags.filter { $0.starts(with:mask) }
        }
        view?.reloadData()
    }
    
    func add(tag: String) {
        if currentTags.contains(tag){
            return
        } else {
            if let index = deletedTags.firstIndex(where: { $0 == tag }) {
                deletedTags.remove(at: index)
                checkCurrentTags()
                view?.reloadData()
            }
            
        }
    }
    
    func remove(tag: String) {
        if currentTags.contains(tag) {
            deletedTags.append(tag)
            checkCurrentTags()
            view?.reloadData()
        }
    }
    
    func getCurrentTags() -> [String] {
        return currentTags
    }
    
    func getFilteredTags() -> [String] {
        return filteredTags
    }
    
    func configureTagListCell(cell: DropOptionTableViewCell, indexPath: IndexPath) {
        let titles = getFilteredTags()
        cell.setupCell(title: titles[indexPath.row])
    }
}
