//
//  DropView.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class DropView: UIView, NibLoadable {

    @IBOutlet weak var dropDownTableView: UITableView!
    
    var presenter: DropViewPresenterProtocol!
    var cellHandler: ((_ tag: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Init drop window")
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        presenter = DropViewPresenter(view: self)
        setupTableView()
    }
  
    func addToList(tags: [String]) {
        for tag in tags {
            presenter.add(tag: tag)
        }
        dropDownTableView.reloadData()
    }
    func addSingle(tag: String) {
        presenter.add(tag: tag)
        dropDownTableView.reloadData()
    }
    
    func removeFromList(tag: String) {
        presenter.remove(tag: tag)
        dropDownTableView.reloadData()
    }
   
    private func setupTableView() {
        //register options cell
        let dropVariantCell = UINib(nibName: DropOptionTableViewCell.identifier, bundle: nil)
        dropDownTableView.register(dropVariantCell, forCellReuseIdentifier: DropOptionTableViewCell.identifier)
    }
}

extension DropView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getTags().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropOptionTableViewCell.identifier, for: indexPath) as! DropOptionTableViewCell
        presenter.configureTagListCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tags = presenter.getTags()
        cellHandler?(tags[indexPath.row])
        removeFromList(tag: tags[indexPath.row])
    }
}
