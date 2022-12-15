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
    var filteringHandler: ((_ mask: String) -> Void)?
    var cellDeleteHandler: ((_ tag: String) -> Void)?
    
    private var tags: [String] = []
    private var cellsWidth: [CGFloat] = []
    private var searchItemPath: [IndexPath]!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func cellInit(tags: [String]) {
        errorTextLabel.isHidden = true
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
    
    private func updateCollectionViewLayout(isFill: Bool) {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell})) as! SearchBarCollectionViewCell
        
        if isFill {
            let leftPoint = cell.frame.minX
            let rightPoint = tagFieldCollectionView.bounds.maxX - 30// collection view right content offset
            let delta = rightPoint - leftPoint
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: delta, height: cell.frame.height)
        }
       
        if cell.bounds.width >= tagFieldCollectionView.bounds.width * 0.9 {
            return
        }
        tagFieldCollectionView.layoutIfNeeded()
        updateFramesHandler?()
    }
    
    func addCell(newTag: String) {
        if tags.contains(newTag) { return }
        if newTag.count <= 2 { return }
        
        tagFieldCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: self.tags.count, section: 0)
            tags.append(newTag) //add your object to data source first
            tagFieldCollectionView.insertItems(at: [indexPath])
        }, completion: {_ in
            self.updateFramesHandler?()
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
        if cell.getStatus() {
            cell.finishFiltering()
        } else {
            if tags.count <= 0
            {
                cell.startFiltering()
            }
        }
    }

    func clearSearchBar() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        cell.finishFiltering()
        updateCollectionViewLayout(isFill: true)
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
                self?.updateCollectionViewLayout(isFill: true)
            }
            cell.filterResults = { [weak self] in
                self?.updateCollectionViewLayout(isFill: false)
                self?.filteringHandler?(cell.getEnters())
                self?.tagFieldCollectionView.collectionViewLayout.invalidateLayout()
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
        deleteCell(index: indexPath)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
