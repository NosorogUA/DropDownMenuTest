//
//  DropDownTagViewController.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

protocol DropDownTagViewControllerProtocol: AnyObject {
    func updateTableViewLayouts()
}

class DropDownTagViewController: UIViewController, DropDownTagViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: DropDownTagPresenterProtocol!
    
    private var transparentView: UIView!
    private var dropTableView: DropView!
    private var dropTableView2: DropView!
    private var currentFrames: CGRect!
    // private var tags: [String] = []
    //private var currentCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropDownTagPresenter(view: self)
        setupTableView()
        setupTransparentView()
        setupDropDownMenu()
    }
    
    private func setupTableView() {
        let dropDownCell = UINib(nibName: DropDownMenuTableViewCell.identifier, bundle: nil)
        tableView.register(dropDownCell, forCellReuseIdentifier: DropDownMenuTableViewCell.identifier)
    }
    
    private func setupDropDownMenu() {
        dropTableView = .fromNib()
        dropTableView.addToList(allTagsList: presenter.getCurrentTags(index: MainControllerCells.tags.rawValue), alreadySelectedTags: [])//current mask on start changing
        dropTableView.layer.cornerRadius = 10
        dropTableView.clipsToBounds = true
        dropTableView.cellHandler = { [weak self] tag in
            self?.presenter.add(tag: tag, index: MainControllerCells.tags.rawValue)
            self?.addToCollection(tag: tag, indexPath: [0, MainControllerCells.tags.rawValue])
        }
        dropTableView.closeHandler = { [weak self] in
            self?.removeTransparentView(index: MainControllerCells.tags.rawValue)
        }
        
        dropTableView2 = .fromNib()
        dropTableView2.addToList(allTagsList: presenter.getCurrentTags(index: MainControllerCells.list.rawValue), alreadySelectedTags: [])//current mask on start changing
        dropTableView2.layer.cornerRadius = 10
        dropTableView2.clipsToBounds = true
        dropTableView2.cellHandler = { [weak self] tag in
            self?.presenter.add(tag: tag, index: MainControllerCells.list.rawValue)
            self?.addToCollection(tag: tag, indexPath: [ 0, MainControllerCells.list.rawValue])
        }
        dropTableView.closeHandler = { [weak self] in
            self?.removeTransparentView(index: MainControllerCells.list.rawValue)
        }
    }
    
    private func setupDropViewFrames(frames: CGRect, index: Int) {
        switch MainControllerCells(rawValue: index) {
        case .tags:
            dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
            self.view.addSubview(dropTableView)
        case .list:
            dropTableView2.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
            self.view.addSubview(dropTableView2)
        case .none:
            print("no cell")
        }
    }
    
    private func calculateFramesDropView(frames: CGRect, index:Int) {
        currentFrames = frames
        //animate showing
        switch MainControllerCells(rawValue: index) {
        case .tags:
            if dropTableView.presenter.getCurrentTags().count > 0 {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transparentView.alpha = 0.5
                    self.dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
                }, completion: nil)
            }
        case .list:
            if dropTableView2.presenter.getCurrentTags().count > 0 {
                UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                    self.transparentView.alpha = 0.5
                    self.dropTableView2.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
                }, completion: nil)
            }
        case .none:
            print("no cell")
        }
        
    }
    
    private func setupTransparentView() {
        // setup background
        transparentView = UIView()
        transparentView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        transparentView.alpha = 0
        self.view.addSubview(transparentView)
    }
    
    private func addDropDownView(frames: CGRect, index: Int) {
        // setup gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        tapGesture.cancelsTouchesInView = false
        transparentView.addGestureRecognizer(tapGesture)
        switch MainControllerCells(rawValue: index) {
        case .tags:
            setupDropViewFrames(frames: frames, index: index)
        case .list:
            setupDropViewFrames(frames: frames, index: index)
        case .none:
            print("no cell")
        }
        calculateFramesDropView(frames: frames, index: index)
    }
    
    @objc func removeTransparentView(index: Int) {
        //animate hiding
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.dropTableView.frame = CGRect(x: self.currentFrames.origin.x + 10, y: self.tableView.frame.origin.y + self.currentFrames.origin.y + self.currentFrames.height, width: self.currentFrames.width * 0.8, height: 0)
        }, completion: { _ in
            self.endFiltering(indexPath: [0, 0])
        })
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.dropTableView2.frame = CGRect(x: self.currentFrames.origin.x + 10, y: self.tableView.frame.origin.y + self.currentFrames.origin.y + self.currentFrames.height, width: self.currentFrames.width * 0.8, height: 0)
        }, completion: { _ in
            self.endFiltering(indexPath: [0, 1])
        })
    }
    
    func updateTableViewLayouts() {
        print("update main table view")
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    
    private func addToCollection(tag: String, indexPath: IndexPath) {
        //let cell = tableView.visibleCells.first(where: ({ $0 is DropDownMenuTableViewCell})) as! DropDownMenuTableViewCell
        let cell = tableView.cellForRow(at: indexPath) as! DropDownMenuTableViewCell
        cell.addCell(newTag: tag)
        filterTags(mask: cell.getMask(), index: indexPath.row)
        updateTableViewLayouts()
    }
    
    private func endFiltering(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DropDownMenuTableViewCell
        //let cell = tableView.visibleCells.first(where: ({ $0 is DropDownMenuTableViewCell})) as! DropDownMenuTableViewCell
        if cell.isEnableCustomTags {
            let newCustomTag = cell.getMask()
            if newCustomTag.count > 3 {
                cell.addCell(newTag: newCustomTag)
                presenter.add(tag: newCustomTag, index: indexPath.row)
            }
            cell.clearSearchBar()
        } else {
            cell.clearSearchBar()
        }
    }
    //MARK: Drop-down menu actions
    private func addTagToDropMenu(_ tag: String, index: Int) {
        switch MainControllerCells(rawValue: index) {
        case .tags:
            dropTableView.addSingle(tag: tag)
        case .list:
            dropTableView2.addSingle(tag: tag)
        case .none:
            print("no cell")
        }
        dropTableView.addSingle(tag: tag)
        presenter.remove(tag: tag, index: index)
    }
    
    private func filterTags(mask: String, index: Int) {
        switch MainControllerCells(rawValue: index) {
        case .tags:
            dropTableView.filterTags(mask: mask)
        case .list:
            dropTableView2.filterTags(mask: mask)
        case .none:
            print("no cell")
        }
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
            presenter.configureDetailCell(cell, index: indexPath.row)
            currentFrames = cell.frame
            cell.variantsButtonHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame, index: indexPath.row)
            }
            cell.startSearchHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame, index: indexPath.row)
            }
            cell.filteringHandler = { [weak self] mask in
                self?.filterTags(mask: mask, index: indexPath.row)
            }
            cell.updateFramesHandler = { [weak self] in
                self?.updateTableViewLayouts()
                if (self?.dropTableView.frame.height)! > 0 {
                    self?.calculateFramesDropView(frames: cell.frame, index: indexPath.row)
                }
            }
            cell.endSearchHandler = { [weak self] in
                self?.dropTableView.clearFilterMask()
            }
            cell.cellDeleteHandler = { [weak self] tag in
                self?.addTagToDropMenu(tag, index: indexPath.row)
                self?.removeTransparentView(index: indexPath.row)
            }
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            print(indexPath)
            presenter.configureDetailCell(cell, index: indexPath.row)
            currentFrames = cell.frame
            cell.variantsButtonHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame, index: indexPath.row)
            }
            cell.startSearchHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame, index: indexPath.row)
            }
            cell.filteringHandler = { [weak self] mask in
                self?.filterTags(mask: mask, index: indexPath.row)
            }
            cell.updateFramesHandler = { [weak self] in
                self?.updateTableViewLayouts()
                if (self?.dropTableView.frame.height)! > 0 {
                    self?.calculateFramesDropView(frames: cell.frame, index: indexPath.row)
                }
            }
            cell.endSearchHandler = { [weak self] in
                self?.dropTableView.clearFilterMask()
            }
            cell.cellDeleteHandler = { [weak self] tag in
                self?.addTagToDropMenu(tag, index: indexPath.row)
                self?.removeTransparentView(index: indexPath.row)
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
