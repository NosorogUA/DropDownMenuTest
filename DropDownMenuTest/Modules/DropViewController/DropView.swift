//
//  DropView.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

protocol DropViewProtocol: AnyObject {
    func reloadData()
}


class DropView: UIView, DropViewProtocol, NibLoadable {

    @IBOutlet private weak var dropDownTableView: UITableView!
    
    var presenter: DropViewPresenterProtocol!
    var cellHandler: ((_ tag: String) -> Void)?
    var closeHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        presenter = DropViewPresenter(view: self)
        setupTableView()
    }
    
    func reloadData() {
        dropDownTableView.reloadData()
    }
    
    private func setupTableView() {
        let dropVariantCell = UINib(nibName: DropOptionTableViewCell.identifier, bundle: nil)
        dropDownTableView.register(dropVariantCell, forCellReuseIdentifier: DropOptionTableViewCell.identifier)
    }
    
    func clearFilterMask() {
        presenter.clearFilterMask()
    }
    
    func filterTags(mask: String) {
        presenter.filterTags(mask: mask)
    }
    
    func addToList(allTagsList: [String], alreadySelectedTags: [String]) {
        presenter.setupAlreadySelectedTagList(tags: alreadySelectedTags)
        presenter.setupStartTagList(tags: allTagsList)
    }
   
    func addSingle(tag: String) {
        presenter.add(tag: tag)
    }
    
    private func removeFromList(tag: String) {
        presenter.remove(tag: tag)
        if presenter.getCurrentTags().count == 0 {
            closeHandler?()
        }
    }
}

extension DropView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getFilteredTags().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropOptionTableViewCell.identifier, for: indexPath) as! DropOptionTableViewCell
        presenter.configureTagListCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tags = presenter.getFilteredTags()
        cellHandler?(tags[indexPath.row])
        removeFromList(tag: tags[indexPath.row])
    }
}
