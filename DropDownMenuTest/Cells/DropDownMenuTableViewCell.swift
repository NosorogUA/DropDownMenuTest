//
//  DropDownMenuTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class DropDownMenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tagFieldCollectionView: UICollectionView!
    @IBOutlet private weak var dropButton: UIButton!
    
    var variantsButtonHandler: (() -> Void)?
    var endSearchHandler: (() -> Void)?
    
    var tags: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func cellInit(tags: [String]) {
        self.tags = tags
        print("apply tags \(self.tags)")
        setupCollectionView()
    }
    
    func updateDropButton(isHidden: Bool) {
        dropButton.isHidden = isHidden
    }
    
    private func setupCollectionView() {
        tagFieldCollectionView.dataSource = self
        tagFieldCollectionView.delegate = self
        //register cell
        let tagCell = UINib(nibName: TagCollectionViewCell.identifier, bundle: nil)
        let searchCell = UINib(nibName: SearchBarCollectionViewCell.identifier, bundle: nil)
        tagFieldCollectionView.register(tagCell, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagFieldCollectionView.register(searchCell, forCellWithReuseIdentifier: SearchBarCollectionViewCell.identifier)
        if let flowLayout = tagFieldCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
           }
    }
    
    private func showDropDownMenu() {
        // show menu and hide button
        variantsButtonHandler?()
        updateDropButton(isHidden: true)
    }
    
    private func hideDropDownMenu() {
        endSearchHandler?()
        updateDropButton(isHidden: false)
    }
    
    @IBAction func dropButtonAction(_ sender: UIButton) {
        showDropDownMenu()
    }
}

extension DropDownMenuTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // get items from view controller
        print("Number of rows \(tags.count)")
        return tags.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // try to setup cell in view
        print("=====Configurate collection view cells")
        if indexPath.row == tags.count{
            print("search")
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.identifier, for: indexPath) as! SearchBarCollectionViewCell
            cell.startSearch = { [weak self] in
                self?.showDropDownMenu()
            }
            cell.endSearch = { [weak self] in
                self?.hideDropDownMenu()
            }
            return cell
        } else {
            print("tag")
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            let tag = tags[indexPath.row]
            cell.cellInit(title: tag)
            return cell
        }
    }
    
}
