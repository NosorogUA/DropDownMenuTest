//
//  DropDownTagConfigurator.swift
//  DropDownMenuTest
//
//  Created by mac on 12/16/22.
//

import Foundation

protocol DropDownTagConfiguratorDelegate: AnyObject {
    func updateFramesInCell(_ cell: DropDownMenuTableViewCell)
    func variantsButtonInCell(_ cell: DropDownMenuTableViewCell)
    func filteringInCell(mask: String)
    func startSearchInCell(_ cell: DropDownMenuTableViewCell)
    func endSearchInCell(_ cell: DropDownMenuTableViewCell)
    func cellDelete(tag: String,_ cell: DropDownMenuTableViewCell)
}

extension DropDownTagConfigurator: DropDownTagConfiguratorDelegate {
    
    func updateFramesInCell(_ cell: DropDownMenuTableViewCell) {
        view?.updateTableViewLayouts()
        if getCurrentDropMenuHeight() > 0 {
            calculateFramesDropView(frames: cell.frame)
        }
    }
    
    func variantsButtonInCell(_ cell: DropDownMenuTableViewCell) {
        addDropDownView(frames: cell.frame)
    }
    
    func filteringInCell(mask: String)  {
        filterTags(mask: mask)
    }
    
    func startSearchInCell(_ cell: DropDownMenuTableViewCell) {
        print("start on configurator")
        addDropDownView(frames: cell.frame)
    }
    
    func endSearchInCell(_ cell: DropDownMenuTableViewCell) {
        endFiltering(cell)
    }
    
    func cellDelete(tag: String,_ cell: DropDownMenuTableViewCell) {
        addTagToDropMenu(tag)
        hideDropView(frames: cell.frame)
    }
}

protocol DropDownTagConfiguratorProtocol {
    init(view: DropDownNeedsProtocol, isCustomTagsEnabled: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?)
    func getFilteredTags() -> [String]
    var dropTableView: DropView { get set }
    var isCustomTagsEnabled: Bool { get set }
    func addDropDownView(frames: CGRect)
    func hideDropView(frames: CGRect)
    func close()
    func add(tag: String)
    func addTagToDropMenu(_ tag: String)
    func remove(tag: String)
    func filterTags(mask: String)
    func getCurrentTags() -> [String]
    func getCurrentDropMenuHeight() -> CGFloat
    func calculateFramesDropView(frames: CGRect)
    func setupDropDownMenu()
    func setupDropViewFrames(frames: CGRect)
    func configureCell(cell: DropDownMenuTableViewCell, indexPath: IndexPath)
}

class DropDownTagConfigurator: DropDownTagConfiguratorProtocol {
    
    private weak var view: DropDownNeedsProtocol?
    weak var cellDelegate: DropDownMenuTableViewCellDelegate?
    
    var dropTableView: DropView
    
    var isCustomTagsEnabled = true
    var customUserTags: [String] = ["custom1"]
    var startTags: [String] = []
    var currentTags: [String] = []
    var customerTags: [String] = []
    var alreadyChosenTags: [String] = []
    var filteredTags: [String] = []
    
    let leftOffset: CGFloat = 20
    
    required init(view: DropDownNeedsProtocol, isCustomTagsEnabled: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?) {
        self.view = view
        self.isCustomTagsEnabled = isCustomTagsEnabled
        self.startTags = currentTags
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
        dropTableView.addToList(allTagsList: getStartTags(), alreadySelectedTags: getAlreadySelectedTags())//current mask on start changing
        dropTableView.layer.cornerRadius = 10
        dropTableView.clipsToBounds = true
        dropTableView.cellHandler = { [weak self] tag in
            self?.add(tag: tag)
            self?.addToCollection(tag: tag)
        }
        dropTableView.closeHandler = { [weak self] in
            self?.view?.removeTransparentView()
        }
    }
    
    func setupDropViewFrames(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
        self.view?.addSubView(subView: dropTableView)
    }
    
    func hideDropView(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
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
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
        if getCurrentTags().count > 0 {
            view?.animateViewsOpen(frames: frames)
        }
    }
    
    func close() {
        //endFiltering(cell)
        guard let cellDelegate else { return }
        cellDelegate.endSearch()
        dropTableView.clearFilterMask()
        hideDropView(frames: cellDelegate.getFrame())
    }
    
    func getCurrentDropMenuHeight() -> CGFloat {
        return dropTableView.frame.height
    }
    
    func addToCollection(tag: String) {
        cellDelegate?.addToCollection(tag: tag)
    }
    
    func addTagToDropMenu(_ tag: String) {
        dropTableView.addSingle(tag: tag)
        remove(tag: tag)
    }
    
    func filterTags(mask: String) {
        dropTableView.filterTags(mask: mask)
    }
    
    func endFiltering(_ cell: DropDownMenuTableViewCell) {
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
                alreadyChosenTags.append(tag)
            }
        } else {
            addCustomTag(tag: tag)
        }
    }
    
    func remove(tag: String) {
        if currentTags.contains(tag) {
            if filteredTags.contains(tag) {
                filteredTags = filteredTags.filter {$0 != tag}
                alreadyChosenTags = alreadyChosenTags.filter {$0 != tag}
            } else {
                return
            }
        } else {
            removeCustomTag(tag: tag)
        }
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
    func getStartTags() -> [String] {
        return startTags
    }
    
    func getAlreadySelectedTags() -> [String] {
        return alreadyChosenTags
    }
    
    func getFilteredTags() -> [String] {
        if isCustomTagsEnabled {
            return filteredTags + customUserTags + alreadyChosenTags
        } else {
            return filteredTags + alreadyChosenTags
        }
    }
    
    func configureCell(cell: DropDownMenuTableViewCell, indexPath: IndexPath) {
        cell.cellInit(tags: getFilteredTags(), enableCustomTags: isCustomTagsEnabled)
        cell.delegate = self
        cellDelegate = cell
    }
}
