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
    func saveTags(custom: [String], selected: [String])
}

protocol DropDownTagViewControllerProtocol: AnyObject {
    
}

class DropDownTagViewController: UIViewController, DropDownTagViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: DropDownTagPresenterProtocol!
    var configurator1: DropDownTagConfiguratorProtocol!
    var configurator2: DropDownTagConfiguratorProtocol!
    var configurator3: DropDownTagConfiguratorProtocol!
    
    private var transparentView: UIView!
    
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
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0
            self.configurator1.close()
            self.configurator2.close()
            self.configurator3.close()
            self.transparentView.removeFromSuperview()
        })
    }
    
    func updateTableViewLayouts() {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        tableView.endUpdates()
    }
    
    func saveTags(custom: [String], selected: [String]) {
        presenter.saveTags(custom: custom, selected: selected)
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch MainControllerCells(rawValue: indexPath.row) {
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            configurator1 = DropDownTagConfigurator(view: self, isCustomTagsEnabled: true, isSingleOption: false, currentTags: presenter.getCurrentTags(), customUserTags: presenter.getCustomTags(), alreadyChosenTags: presenter.getUsedTags())
            configurator1.configureCell(title: presenter.getTitle(index: indexPath.row), cell: cell, indexPath: indexPath)
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            configurator2 = DropDownTagConfigurator(view: self, isCustomTagsEnabled: false, isSingleOption: false, currentTags: presenter.getCurrentTags2(), customUserTags: presenter.getCustomTags2(), alreadyChosenTags: presenter.getUsedTags2())
            configurator2.configureCell(title: presenter.getTitle(index: indexPath.row), cell: cell, indexPath: indexPath)
            cell.layoutIfNeeded()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        case .single:
            let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
            configurator3 = DropDownTagConfigurator(view: self, isCustomTagsEnabled: false, isSingleOption: true, currentTags: presenter.getCurrentTags2(), customUserTags: presenter.getCustomTags2(), alreadyChosenTags: presenter.getUsedTags2())
            configurator3.configureCell(title: presenter.getTitle(index: indexPath.row), cell: cell, indexPath: indexPath)
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
