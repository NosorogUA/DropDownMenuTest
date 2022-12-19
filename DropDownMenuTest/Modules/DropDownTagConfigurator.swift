//
//  DropDownTagConfigurator.swift
//  DropDownMenuTest
//
//  Created by mac on 12/16/22.
//

import Foundation

protocol DropDownTagConfiguratorProtocol {
    init(view: DropDownNeedsProtocol, cell: DropDownMenuTableViewCell, isCustomTagsEnabled: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?)
    func getFilteredTags() -> [String]
    var dropTableView: DropView { get set }
    var cell: DropDownMenuTableViewCell { get set }
    var isCustomTagsEnabled: Bool { get set }
    func addDropDownView(frames: CGRect)
    func hideDropView(frames: CGRect)
    func add(tag: String)
    func addTagToDropMenu(_ tag: String)
    func remove(tag: String)
    func filterTags(mask: String)
    func getCurrentTags() -> [String]
    func endFiltering()
    func getCurrentDropMenuHeight() -> CGFloat
    func calculateFramesDropView(frames: CGRect)
    func setupDropDownMenu()
    func setupDropViewFrames(frames: CGRect)
}

class DropDownTagConfigurator: DropDownTagConfiguratorProtocol {
    
    private weak var view: DropDownNeedsProtocol?
    var dropTableView: DropView
    var cell: DropDownMenuTableViewCell
    
    var isCustomTagsEnabled = true
    var customUserTags: [String] = ["custom1"] {
        didSet {
            print(customUserTags)
        }
    }
    var startTags: [String] = []
    var currentTags: [String] = []
    var customerTags: [String] = []
    var alreadyChosenTags: [String] = []
    var filteredTags: [String] = []
    
    required init(view: DropDownNeedsProtocol, cell: DropDownMenuTableViewCell, isCustomTagsEnabled: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?) {
        self.view = view
        self.isCustomTagsEnabled = isCustomTagsEnabled
        self.startTags = currentTags
        self.cell = cell
        self.customUserTags = customUserTags ?? []
        self.alreadyChosenTags = alreadyChosenTags ?? []
        if alreadyChosenTags!.count > 0 {
            self.currentTags = startTags.filter{ !alreadyChosenTags!.contains($0) }
        } else {
            self.currentTags = startTags
        }
        dropTableView = .fromNib()
        self.setupDropDownMenu()
    }
    
    
    //MARK: Drop-down menu
    func setupDropDownMenu() {
        dropTableView.addToList(allTagsList: getCurrentTags(), alreadySelectedTags: [])//current mask on start changing
        dropTableView.layer.cornerRadius = 10
        dropTableView.clipsToBounds = true
        dropTableView.cellHandler = { [weak self] tag in
            self?.add(tag: tag)
            self?.addToCollection(tag: tag)
        }
        dropTableView.closeHandler = { [weak self] in
            self?.view?.removeTransparentView()
            self?.endFiltering()
        }
    }
    
    func setupDropViewFrames(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
        self.view?.addSubView(subView: dropTableView)
    }
    
    func hideDropView(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
    }
    
    func addDropDownView(frames: CGRect) {
        // setup gesture
        view?.setupTransparentView()
        setupDropViewFrames(frames: frames)
        calculateFramesDropView(frames: frames)
        
    }
    
    func calculateFramesDropView(frames: CGRect) {
        //animate showing
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
        if getCurrentTags().count > 0 {
            view?.animateViewsOpen(frames: frames)
        }
    }
    
    func getCurrentDropMenuHeight() -> CGFloat {
        return dropTableView.frame.height
    }
    
    private func addToCollection(tag: String) {
        cell.addCell(newTag: tag)
        filterTags(mask: cell.getMask())
        view?.updateTableViewLayouts()
    }
    
    func addTagToDropMenu(_ tag: String) {
        dropTableView.addSingle(tag: tag)
        dropTableView.addSingle(tag: tag)
        remove(tag: tag)
    }
    
    func filterTags(mask: String) {
        dropTableView.filterTags(mask: mask)
    }
    
    func endFiltering() {
        if cell.isEnableCustomTags {
            let newCustomTag = cell.getMask()
            if newCustomTag.count > 3 {
                cell.addCell(newTag: newCustomTag)
                add(tag: newCustomTag)
            }
        }
        cell.clearSearchBar()
        dropTableView.clearFilterMask()
    }
    
    //MARK: Actions with tags
    func add(tag: String) {
        if currentTags.contains(tag) {
            if filteredTags.contains(tag) {
                return
            } else {
                filteredTags.append(tag)
            }
        } else {
            addCustomTag(tag: tag)
        }
        view?.updateTableViewLayouts()
    }
    
    func remove(tag: String) {
        if currentTags.contains(tag) {
            if filteredTags.contains(tag) {
                filteredTags = filteredTags.filter {$0 != tag}
            } else {
                return
            }
        } else {
            removeCustomTag(tag: tag)
        }
        view?.updateTableViewLayouts()
    }
    
    func addCustomTag(tag: String) {
        if customUserTags.contains(tag) {
            return
        } else {
            customUserTags.append(tag)
        }
    }
    
    func removeCustomTag(tag: String) {
        if customUserTags.contains(tag) {
            customUserTags = customUserTags.filter {$0 != tag}
        } else {
            return
        }
    }
    
    func getCurrentTags() -> [String] {
        return currentTags
    }
    
    func getFilteredTags() -> [String] {
        if isCustomTagsEnabled {
            return filteredTags + customUserTags + alreadyChosenTags
        } else {
            return filteredTags + alreadyChosenTags
        }
    }
}
