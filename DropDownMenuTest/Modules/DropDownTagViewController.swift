//
//  DropDownTagViewController.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

protocol DropDownNeedsProtocol: AnyObject {
    func addSubView(subView: DropView)
    func getViewFrames() -> CGRect
    func animateViewsOpen(frames: CGRect)
    func setupTransparentView()
    func removeTransparentView()
    func updateTableViewLayouts()
}

protocol DropDownTagViewControllerProtocol: AnyObject {
    
    
}

class DropDownTagViewController: UIViewController, DropDownTagViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: DropDownTagPresenterProtocol!
    var configurator1: DropDownTagConfiguratorProtocol!
    var configurator2: DropDownTagConfiguratorProtocol!
    
    private var transparentView: UIView!
    //private var dropTableView: DropView!
    //private var dropTableView2: DropView!
    private var currentFrames: CGRect!
    // private var tags: [String] = []
    //private var currentCellIndex: Int?
    var selectedCellConfigurator: DropDownTagConfiguratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropDownTagPresenter(view: self)
        setupTableView()
        //setupTransparentView()
        //setupDropDownMenu()
    }
    
    private func setupTableView() {
        let dropDownCell = UINib(nibName: DropDownMenuTableViewCell.identifier, bundle: nil)
        tableView.register(dropDownCell, forCellReuseIdentifier: DropDownMenuTableViewCell.identifier)
    }
    
    
    
//    private func setupDropDownMenu() {
//        dropTableView = .fromNib()
//        dropTableView.addToList(allTagsList: presenter.getCurrentTags(index: MainControllerCells.tags.rawValue), alreadySelectedTags: [])//current mask on start changing
//        dropTableView.layer.cornerRadius = 10
//        dropTableView.clipsToBounds = true
//        dropTableView.cellHandler = { [weak self] tag in
//            self?.presenter.add(tag: tag, index: MainControllerCells.tags.rawValue)
//            self?.addToCollection(tag: tag, indexPath: [0, MainControllerCells.tags.rawValue])
//        }
//        dropTableView.closeHandler = { [weak self] in
//            self?.removeTransparentView()
//        }
//
//        dropTableView2 = .fromNib()
//        dropTableView2.addToList(allTagsList: presenter.getCurrentTags(index: MainControllerCells.list.rawValue), alreadySelectedTags: [])//current mask on start changing
//        dropTableView2.layer.cornerRadius = 10
//        dropTableView2.clipsToBounds = true
//        dropTableView2.cellHandler = { [weak self] tag in
//            self?.presenter.add(tag: tag, index: MainControllerCells.list.rawValue)
//            self?.addToCollection(tag: tag, indexPath: [ 0, MainControllerCells.list.rawValue])
//        }
//        dropTableView.closeHandler = { [weak self] in
//            self?.removeTransparentView()
//        }
//    }
    
//    private func setupDropViewFrames(frames: CGRect, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
//            self.view.addSubview(dropTableView)
//        case .list:
//            dropTableView2.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
//            self.view.addSubview(dropTableView2)
//        case .none:
//            print("no cell")
//        }
//    }
    
//    private func calculateFramesDropView(frames: CGRect, index:Int) {
//        currentFrames = frames
//        //animate showing
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            if dropTableView.presenter.getCurrentTags().count > 0 {
//                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//                    self.transparentView.alpha = 0.5
//                    self.dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
//                }, completion: nil)
//            }
//        case .list:
//            if dropTableView2.presenter.getCurrentTags().count > 0 {
//                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
//                    self.transparentView.alpha = 0.5
//                    self.dropTableView2.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
//                }, completion: nil)
//            }
//        case .none:
//            print("no cell")
//        }
//
//    }
    func calculateFramesDropView(frames: CGRect, configurator: DropDownTagConfiguratorProtocol) {
        if configurator1.getCurrentTags().count > 0 {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0.5
//                self.dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.view?.getViewFrames().origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
                configurator.calculateFramesDropView(frames: frames)
            }, completion: nil)
        }
        
    }
    
    
    
//    private func addDropDownView(frames: CGRect, index: Int) {
//        // setup gesture
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            setupDropViewFrames(frames: frames, index: index)
//        case .list:
//            setupDropViewFrames(frames: frames, index: index)
//        case .none:
//            print("no cell")
//        }
//        calculateFramesDropView(frames: frames, index: index)
//    }
    
    @objc func removeTransparentView() {
        //animate hiding
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
//            self.dropTableView.frame = CGRect(x: self.currentFrames.origin.x + 10, y: self.tableView.frame.origin.y + self.currentFrames.origin.y + self.currentFrames.height, width: self.currentFrames.width * 0.8, height: 0)
            self.selectedCellConfigurator?.endFiltering()
            self.selectedCellConfigurator?.dropTableView.clearFilterMask()
            self.selectedCellConfigurator?.hideDropView(frames: self.currentFrames)
            self.transparentView.removeFromSuperview()
            
        })
    }
    
    func updateTableViewLayouts() {
        print("update main table view")
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    
//    private func addToCollection(tag: String, indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! DropDownMenuTableViewCell
//        cell.addCell(newTag: tag)
//        filterTags(mask: cell.getMask(), index: indexPath.row)
//        updateTableViewLayouts()
//    }
    
//    private func endFiltering(indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! DropDownMenuTableViewCell
//        if cell.isEnableCustomTags {
//            let newCustomTag = cell.getMask()
//            if newCustomTag.count > 3 {
//                cell.addCell(newTag: newCustomTag)
//                presenter.add(tag: newCustomTag, index: indexPath.row)
//            }
//            cell.clearSearchBar()
//        } else {
//            cell.clearSearchBar()
//        }
//        switch MainControllerCells(rawValue: indexPath.row) {
//        case .tags:
//            dropTableView.clearFilterMask()
//        case .list:
//            dropTableView2.clearFilterMask()
//        case .none:
//            print("no cell")
//        }
//
//    }
    //MARK: Drop-down menu actions
//    private func addTagToDropMenu(_ tag: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            dropTableView.addSingle(tag: tag)
//        case .list:
//            dropTableView2.addSingle(tag: tag)
//        case .none:
//            print("no cell")
//        }
//        dropTableView.addSingle(tag: tag)
//        presenter.remove(tag: tag, index: index)
//    }
//
//    private func filterTags(mask: String, index: Int) {
//        switch MainControllerCells(rawValue: index) {
//        case .tags:
//            dropTableView.filterTags(mask: mask)
//        case .list:
//            dropTableView2.filterTags(mask: mask)
//        case .none:
//            print("no cell")
//        }
//    }
}

extension DropDownTagViewController: DropDownNeedsProtocol {
    func addSubView(subView: DropView) {
        self.view.addSubview(subView)
    }
    func getViewFrames() -> CGRect {
        return self.tableView.frame
    }
    
    func setupTransparentView() {
        // setup background
        transparentView = UIView()
        transparentView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        transparentView.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        tapGesture.cancelsTouchesInView = false
        transparentView.addGestureRecognizer(tapGesture)
        self.view.addSubview(transparentView)
    }

    func animateViewsOpen(frames: CGRect) {
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
        }, completion: nil)
    }
}

extension DropDownTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch MainControllerCells(rawValue: indexPath.row) {
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            //presenter.configureDetailCell(cell, index: indexPath.row)
            currentFrames = cell.frame
            configurator1 = DropDownTagConfigurator(view: self, cell: cell, isCustomTagsEnabled: true, currentTags: presenter.getCurrentTags(), customUserTags: presenter.getCustomTags(), alreadyChosenTags: presenter.getUsedTags())
            cell.cellInit(tags: configurator1.getFilteredTags(), enableCustomTags: configurator1.isCustomTagsEnabled)
            cell.variantsButtonHandler = { [weak self] in
                self?.configurator1.addDropDownView(frames: cell.frame)
                self?.selectedCellConfigurator = self?.configurator1
            }
            cell.startSearchHandler = { [weak self] in
                self?.configurator1.addDropDownView(frames: cell.frame)
                self?.selectedCellConfigurator = self?.configurator1
            }
            cell.filteringHandler = { [weak self] mask in
                self?.configurator1.filterTags(mask: mask)
            }
            cell.updateFramesHandler = { [weak self] in
                self?.updateTableViewLayouts()
                if (self?.configurator1.getCurrentDropMenuHeight())! > 0 {
                    self?.configurator1.calculateFramesDropView(frames: cell.frame)
                }
            }
            cell.endSearchHandler = { [weak self] in
                print("Cell1 end search")
                self?.configurator1.endFiltering()
                
            }
            cell.cellDeleteHandler = { [weak self] tag in
                self?.configurator1.addTagToDropMenu(tag)
                //self?.removeTransparentView()
                self?.configurator1.hideDropView(frames: cell.frame)
            }
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            print(indexPath)
            //presenter.configureDetailCell(cell, index: indexPath.row)
            currentFrames = cell.frame
            configurator2 = DropDownTagConfigurator(view: self, cell: cell, isCustomTagsEnabled: false, currentTags: presenter.getCurrentTags2(), customUserTags: presenter.getCustomTags2(), alreadyChosenTags: presenter.getUsedTags2())
            cell.cellInit(tags: configurator2.getFilteredTags(), enableCustomTags: configurator2.isCustomTagsEnabled)
            cell.variantsButtonHandler = { [weak self] in
                self?.configurator2.addDropDownView(frames: cell.frame)
            }
            cell.startSearchHandler = { [weak self] in
                self?.configurator2.addDropDownView(frames: cell.frame)
                self?.selectedCellConfigurator = self?.configurator2
            }
            cell.filteringHandler = { [weak self] mask in
                self?.configurator2.filterTags(mask: mask)
                self?.selectedCellConfigurator = self?.configurator2
            }
            cell.updateFramesHandler = { [weak self] in
                self?.updateTableViewLayouts()
                if (self?.configurator2.getCurrentDropMenuHeight())! > 0 {
                    self?.configurator2.calculateFramesDropView(frames: cell.frame)
                }
            }
            cell.endSearchHandler = { [weak self] in
                print("Cell2 end search")
                self?.configurator2.endFiltering()
            }
            cell.cellDeleteHandler = { [weak self] tag in
                self?.configurator2.addTagToDropMenu(tag)
                //self?.removeTransparentView()
                self?.configurator2.hideDropView(frames: cell.frame)
            }
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}
