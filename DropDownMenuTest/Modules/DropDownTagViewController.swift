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
    private var currentFrames: CGRect!
    private var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropDownTagPresenter(view: self)
        setupTableView()
        setupDropDownMenu()
    }
    
    private func setupTableView() {
        let dropDownCell = UINib(nibName: DropDownMenuTableViewCell.identifier, bundle: nil)
        tableView.register(dropDownCell, forCellReuseIdentifier: DropDownMenuTableViewCell.identifier)
    }
    
    private func setupDropDownMenu() {
        dropTableView = .fromNib()
        dropTableView.addToList(allTagsList: presenter.getCurrentTags(), alreadySelectedTags: [])
        dropTableView.layer.cornerRadius = 10
        dropTableView.clipsToBounds = true
        dropTableView.cellHandler = { [weak self] tag in
            self?.presenter.add(tag: tag)
            self?.addToCollection(tag: tag)
        }
        dropTableView.closeHandler = { [weak self] in
            self?.removeTransparentView()
        }
    }
    
    private func setupDropViewFrames(frames: CGRect) {
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 0)
        self.view.addSubview(dropTableView)
    }
    
    private func calculateFramesDropView(frames: CGRect) {
        currentFrames = frames
        //animate showing
        if dropTableView.presenter.getFilteredTags().count > 0 {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0.5
                self.dropTableView.frame = CGRect(x: frames.origin.x + 10, y: self.tableView.frame.origin.y + frames.origin.y + frames.height, width: frames.width * 0.8, height: 200)
            }, completion: nil)
        }
    }
    
    private func addDropDownView(frames: CGRect) {
        // setup background
        transparentView = UIView()
        transparentView.frame = UIApplication.shared.keyWindow?.frame ?? self.view.frame
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        transparentView.alpha = 0
        self.view.addSubview(transparentView)
        
        // setup gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        tapGesture.cancelsTouchesInView = false
        transparentView.addGestureRecognizer(tapGesture)
        setupDropViewFrames(frames: frames)
        calculateFramesDropView(frames: frames)
    }
    
    @objc func removeTransparentView() {
        //animate hiding
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.dropTableView.frame = CGRect(x: self.currentFrames.origin.x + 10, y: self.tableView.frame.origin.y + self.currentFrames.origin.y + self.currentFrames.height, width: self.currentFrames.width * 0.8, height: 0)
        }, completion: { _ in
            self.endFiltering()
            //self.filtering()
            self.transparentView.removeFromSuperview()
        })
    }
    
    func updateTableViewLayouts() {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    
    private func addToCollection(tag: String) {
        let cell = tableView.visibleCells.first(where: ({ $0 is DropDownMenuTableViewCell})) as! DropDownMenuTableViewCell
        cell.addCell(newTag: tag)
        filterTags(mask: cell.getMask())
        updateTableViewLayouts()
    }
    
    private func endFiltering() {
        let cell = tableView.visibleCells.first(where: ({ $0 is DropDownMenuTableViewCell})) as! DropDownMenuTableViewCell
        cell.clearSearchBar()
    }
    //MARK: Drop-down menu actions
    private func addTagToDropMenu(_ tag: String) {
        dropTableView.addSingle(tag: tag)
        presenter.remove(tag: tag)
    }
    
    private func filterTags(mask: String) {
        dropTableView.filterTags(mask: mask)
    }
}

extension DropDownTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch MainControllerCells(rawValue: indexPath.row) {
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            presenter.configureDetailCell(cell)
            cell.variantsButtonHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame)
            }
            cell.startSearchHandler = { [weak self] in
                self?.addDropDownView(frames: cell.frame)
            }
            cell.filteringHandler = { [weak self] mask in
                self?.filterTags(mask: mask)
            }
            cell.updateFramesHandler = { [weak self] in
                self?.updateTableViewLayouts()
                if (self?.dropTableView.frame.height)! > 0 {
                    self?.calculateFramesDropView(frames: cell.frame)
                }
            }
            cell.cellDeleteHandler = { [weak self] tag in
                self?.addTagToDropMenu(tag)
                self?.removeTransparentView()
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
