//
//  DropDownMenuTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit


class DropDownMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tagFieldCollectionView: UICollectionView!
    @IBOutlet private weak var dropButton: UIButton!
    
    var variantsButtonHandler: (() -> Void)?
    var startSearchHandler: (() -> Void)?
    var updateFramesHandler: (() -> Void)?
    var cellDeleteHandler: ((_ tag: String) -> Void)?
    
    var tags: [String] = []
    var searchItemPath: [IndexPath]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func cellInit(tags: [String]) {
        self.tags = tags
        tagFieldCollectionView.reloadData()
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
            
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 0
            
            tagFieldCollectionView.collectionViewLayout = flowLayout
        }
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
//        tap.cancelsTouchesInView = false
//        tagFieldCollectionView.addGestureRecognizer(tap)
    }
    
    func updateCollectionViewLayout() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell})) as! SearchBarCollectionViewCell
        if cell.bounds.width >= tagFieldCollectionView.bounds.width * 0.85 {
            return
        }
        tagFieldCollectionView.layoutIfNeeded()
        tagFieldCollectionView.reconfigureItems(at: searchItemPath)
        updateFramesHandler?()
    }
    
    func addCell(newTag: String) {
        if tags.contains(newTag) { return }
        if newTag.count <= 2 { return }
        
        tagFieldCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: self.tags.count, section: 0)
            tags.append(newTag) //add your object to data source first
            tagFieldCollectionView.insertItems(at: [indexPath])
        }, completion: nil)
    }
    
    func deleteCell(index: IndexPath) {
        let tag = tags[index.row]
        tagFieldCollectionView.performBatchUpdates({
            tags.remove(at: index.row) //add your object to data source first
            tagFieldCollectionView.deleteItems(at: [index])
        }, completion: { _ in
            self.cellDeleteHandler?(tag)
        })
    }
    
    private func hideDropDownMenu() {
        updateDropButton(isHidden: false)
    }
    
    func filterResults(enters: String) {
        print(enters)
    }
    
    func clearSearchBar() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        cell.finishEditing()
    }
    
    @IBAction func dropButtonAction(_ sender: UIButton) {
        variantsButtonHandler?()
        updateDropButton(isHidden: true)
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
        print("=====Configure collection view cells")
        if indexPath.row == tags.count{
            print("search")
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.identifier, for: indexPath) as! SearchBarCollectionViewCell
            searchItemPath = [indexPath]
            cell.startSearch = { [weak self] in
                self?.startSearchHandler?()
            }
            cell.endSearch = { [weak self] in
                self?.hideDropDownMenu()
                self?.addCell(newTag: cell.getEnters())
            }
            cell.filterResults = { [weak self] in
                self?.updateCollectionViewLayout()
                self?.filterResults(enters: cell.getEnters())
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteCell(index: indexPath)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
