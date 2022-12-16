//
//  DropDownMenuTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class DropDownMenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tagFieldCollectionView: DynamicHeightCollectionView!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    
    var variantsButtonHandler: (() -> Void)?
    var startSearchHandler: (() -> Void)?
    var updateFramesHandler: (() -> Void)?
    var endSearchHandler: (() -> Void)?
    var filteringHandler: ((_ mask: String) -> Void)?
    var cellDeleteHandler: ((_ tag: String) -> Void)?
    
    private var tags: [String] = []
    private var cellsWidth: [CGFloat] = []
    private var searchItemPath: [IndexPath]!
    
    var isEnableCustomTags: Bool = false// change option for enable/disable customization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func cellInit(tags: [String], enableCustomTags: Bool) {
        errorTextLabel.isHidden = true
        isEnableCustomTags = enableCustomTags
        self.tags = tags
        tagFieldCollectionView.reloadData()
    }
    
    private func setupCollectionView() {
        tagFieldCollectionView.dataSource = self
        tagFieldCollectionView.delegate = self
        tagFieldCollectionView.layer.cornerRadius = 16
        tagFieldCollectionView.clipsToBounds = true
        tagFieldCollectionView.touchHandler = {[weak self] in
            self?.gestureConfigure()
        }
        
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
    }
    
    private func updateCollectionViewLayout() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell})) as! SearchBarCollectionViewCell
        
        if cell.bounds.width >= tagFieldCollectionView.bounds.width * 0.9 {
            return
        }
        tagFieldCollectionView.layoutIfNeeded()
        tagFieldCollectionView.collectionViewLayout.invalidateLayout()
        updateFramesHandler?()
    }
    
    func addCell(newTag: String) {
        if !isEnableCustomTags {
            if tags.contains(newTag) { return }
        }
        if newTag.count <= 2 { return }
        print("add tag cell \(newTag)")
        tagFieldCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: self.tags.count, section: 0)
            tags.append(newTag) //add your object to data source first
            tagFieldCollectionView.insertItems(at: [indexPath])
        })
    }
    
    private func deleteCell(index: IndexPath) {
        let tag = tags[index.row]
        tagFieldCollectionView.performBatchUpdates({
            tags.remove(at: index.row) //delete your object to data source first
            tagFieldCollectionView.deleteItems(at: [index])
        }, completion: { _ in
            self.cellDeleteHandler?(tag)
        })
    }
    
    private func gestureConfigure() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        
        print(cell.getStatus())
        if cell.getStatus() {
            cell.finishFiltering()
        } else {
            cell.startFiltering()
        }
    }
    
    func getMask () -> String {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        return cell.getEnters()
    }
    
    func clearSearchBar() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        cell.finishFiltering()
        updateCollectionViewLayout()
    }
    
    private func updateRightIcon(isHidden: Bool) {
        rightImageView.isHidden = isHidden
    }
    
    //MARK: check field before next step
    func isPassed() -> Bool {
        if tags.count > 0 {
            return true
        } else {
            errorTextLabel.isHidden = false
            //apply text here
            errorTextLabel.text = "NEED TO SETUP"
            return false
        }
    }
}

extension DropDownMenuTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == tags.count{
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.identifier, for: indexPath) as! SearchBarCollectionViewCell
            searchItemPath = [indexPath]
            cell.startSearch = { [weak self] in
                self?.startSearchHandler?()
                self?.updateRightIcon(isHidden: true)
            }
            cell.endSearch = { [weak self] in
                self?.updateRightIcon(isHidden: false)
                self?.addCell(newTag: cell.getEnters())
                self?.updateCollectionViewLayout()
                self?.endSearchHandler?()
            }
            cell.filterResults = { [weak self] in
                self?.updateCollectionViewLayout()
                self?.filteringHandler?(cell.getEnters())
            }
            return cell
        } else {
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            let tag = tags[indexPath.row]
            cell.cellInit(title: tag)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.tagFieldCollectionView.cellForItem(at: indexPath) as? TagCollectionViewCell {
            deleteCell(index: indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
