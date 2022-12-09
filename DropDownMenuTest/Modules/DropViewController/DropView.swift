//
//  DropView.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class DropView: UIView, NibLoadeble {

    @IBOutlet weak var dropDownTableView: UITableView!
    
    var presenter: DropViewPresenter!
    var tags: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter = DropViewPresenter(view: self)
        setupTableView()
    }
   
    func setupTableView() {
        //register options cell
        let dropVariantCell = UINib(nibName: DropOptionTableViewCell.identifier, bundle: nil)
        dropDownTableView.register(dropVariantCell, forCellReuseIdentifier: DropOptionTableViewCell.identifier)
    }
}

extension DropView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tags = presenter.getTags()
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("configure drop cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: DropOptionTableViewCell.identifier, for: indexPath) as! DropOptionTableViewCell
        presenter.configureTagListCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    
}
