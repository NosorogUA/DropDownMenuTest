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
    private var currentFrames: CGRect!
    var selectedCellConfigurator: DropDownTagConfiguratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = DropDownTagPresenter(view: self)
        setupTableView()
    }
    
    private func setupTableView() {
        let dropDownCell = UINib(nibName: DropDownMenuTableViewCell.identifier, bundle: nil)
        tableView.register(dropDownCell, forCellReuseIdentifier: DropDownMenuTableViewCell.identifier)
    }

    func calculateFramesDropView(frames: CGRect, configurator: DropDownTagConfiguratorProtocol) {
        if configurator1.getCurrentTags().count > 0 {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                self.transparentView.alpha = 0.5
                configurator.calculateFramesDropView(frames: frames)
            }, completion: nil)
        }
        
    }
    
    @objc func removeTransparentView() {
        //animate hiding
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
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
