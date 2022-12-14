//
//  DropDownTagConfigurator.swift
//  DropDownMenuTest
//
//  Created by mac on 12/16/22.
//

import Foundation
import UIKit

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
            var frame = cell.frame
            frame.origin.y -= view?.verticalContentOffset ?? 0
            calculateFramesDropView(frames: frame)
        }
    }
    
    func variantsButtonInCell(_ cell: DropDownMenuTableViewCell) {
       // addDropDownView(frames: cell.frame)
        addDropDownViewFor(target: cell)
    }
    
    func filteringInCell(mask: String)  {
        filterTags(mask: mask)
    }
    
    func startSearchInCell(_ cell: DropDownMenuTableViewCell) {
        print("start on configurator")
        //addDropDownView(frames: cell.frame)
        addDropDownViewFor(target: cell)
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
    init(view: DropDownNeedsProtocol, isCustomTagsEnabled: Bool, isSingleOption: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?)
    func getFilteredTags() -> [String]
    var dropTableView: DropView { get set }
    var isCustomTagsEnabled: Bool { get set }
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
    func configureCell(title: String, cell: DropDownMenuTableViewCell, indexPath: IndexPath)
    func saveTags()
}

class DropDownTagConfigurator: DropDownTagConfiguratorProtocol {
    
    private weak var view: DropDownNeedsProtocol?
    weak var cellDelegate: DropDownMenuTableViewCellDelegate?
    
    var dropTableView: DropView
    
    var isCustomTagsEnabled = true
    var isSingleOption = false
    
    var customUserTags: [String] = ["custom1"]
    var startTags: [String] = []
    var currentTags: [String] = []
    var customerTags: [String] = []
    var alreadyChosenTags: [String] = []
    var filteredTags: [String] = []
    
    let leftOffset: CGFloat = 20
    let dropDownMenuHeight: CGFloat = 200
    
    required init(view: DropDownNeedsProtocol, isCustomTagsEnabled: Bool, isSingleOption: Bool, currentTags: [String], customUserTags: [String]?, alreadyChosenTags: [String]?) {
        self.view = view
        self.isCustomTagsEnabled = isCustomTagsEnabled
        self.isSingleOption = isSingleOption
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
            guard let self else { return }
            if self.isSingleOption {
                //remove first tag
                self.view?.removeTransparentView()
                //self.close()
                self.cellDelegate?.deleteCell()
                self.add(tag: tag)
                self.addToCollection(tag: tag)
            } else {
                self.add(tag: tag)
                self.addToCollection(tag: tag)
            }
            
        }
        dropTableView.closeHandler = { [weak self] in
            self?.view?.removeTransparentView()
            //self?.close()
        }
    }
    
    func setupDropViewFrames(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.isHidden = false
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
        self.view?.addSubView(subView: dropTableView)
    }
    
    func hideDropView(frames: CGRect) {
        guard let viewFrames = view?.getViewFrames() else { return }
        dropTableView.isHidden = true
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: viewFrames.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
    }
    
//    func addDropDownView(frames: CGRect) {
//        // setup gesture
//        view?.setupTransparentView(configurator: self)///
//        setupDropViewFrames(frames: frames)
//        calculateFramesDropView(frames: frames)
//
//    }
    
    func addDropDownViewFor(target: UIView) {
        // setup gesture
        //let frame = target.convert(target.frame, to: dropTableView)
        var frame = target.frame
        frame.origin.y -= view?.verticalContentOffset ?? 0
        print(target.frame)
        print(frame)
        print(dropTableView.frame)
        view?.setupTransparentView(configurator: self)///
        setupDropViewFrames(frames: frame)
        calculateFramesDropView(frames: frame)
        
    }
    
    func calculateFramesDropView(frames: CGRect) {
        //animate showing
        guard let viewFrames = view?.getViewFrames() else { return }
        var y: CGFloat = 0
        if frames.maxY < viewFrames.height / 2 {
            y = viewFrames.origin.y + frames.origin.y + frames.height
        } else {
            y = viewFrames.origin.y + frames.origin.y - dropDownMenuHeight
        }
        
        dropTableView.frame = CGRect(x: frames.origin.x + leftOffset, y: y, width: frames.width * 0.8, height: dropDownMenuHeight)
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
    
    func configureCell(title: String, cell: DropDownMenuTableViewCell, indexPath: IndexPath) {
        cell.cellInit(title: title, tags: getFilteredTags(), enableCustomTags: isCustomTagsEnabled)
        cell.delegate = self
        cellDelegate = cell
    }
    
    func saveTags() {
        // push tags to presenter
        view?.saveTags(custom: customUserTags, selected: alreadyChosenTags)
    }
}
