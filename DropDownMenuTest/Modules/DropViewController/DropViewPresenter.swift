//
//  DropViewPresenter.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import Foundation

protocol DropViewPresenterProtocol {
    init(view: DropViewProtocol)
    func setupAlreadySelectedTagList(tags: [String])
    func setupStartTagList(tags: [String])
    func clearFilterMask()
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
    var alreadySelectedTags: [String] = []
    var filteredTags: [String] = []
    
    private var currentMask: String?
    
    required init(view: DropViewProtocol) {
        self.view = view
    }
    
    func setupAlreadySelectedTagList(tags: [String]) {
        for tag in tags {
            alreadySelectedTags.append(tag)
        }
    }
    
    func setupStartTagList(tags: [String]) {
        for tag in tags {
            startTags.append(tag)
        }
        print("setupStartTagList \(startTags)")
        checkCurrentTags()
        filterTags(mask: "")
        view?.reloadData()
    }
    
    func checkCurrentTags() {
        currentTags = startTags.filter { !alreadySelectedTags.contains($0) }
        print("start tags: \(startTags), current tags: \(currentTags)")
        filterTags(mask: currentMask ?? "")
    }
    
    func filterTags(mask: String) {
        print("current mask: \(currentMask)/filter with mask: \(mask)")
        if mask == "" {
            filteredTags = currentTags
        } else {
            currentMask = mask
            filteredTags = currentTags.filter { $0.starts(with:mask) }
        }
        if filteredTags.count == 0 {
            currentMask = ""
        }
        view?.reloadData()
    }
    
    func clearFilterMask() {
        print("clear mask")
        currentMask = ""
        filterTags(mask: "")
    }
    
    func add(tag: String) {
        print("DropView Add tag \(tag)")
        if currentTags.contains(tag){
            print("return")
            return
        } else {
            print("add")
            alreadySelectedTags =  alreadySelectedTags.filter {$0 != tag}
            print(alreadySelectedTags)
                checkCurrentTags()
                view?.reloadData()
            
            
        }
    }
    
    func remove(tag: String) {
        if currentTags.contains(tag) {
            alreadySelectedTags.append(tag)
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
