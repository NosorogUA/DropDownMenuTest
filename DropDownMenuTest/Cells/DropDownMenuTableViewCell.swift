//
//  DropDownMenuTableViewCell.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

protocol DropDownMenuTableViewCellDelegate: AnyObject {
    func addToCollection(tag: String)
    func endSearch()
    func getFrame() -> CGRect
    func deleteCell()
}

extension DropDownMenuTableViewCell: DropDownMenuTableViewCellDelegate {
    func addToCollection(tag: String) {
        addCell(newTag: tag)
        delegate?.filteringInCell(mask: getMask())
    }
    func endSearch()
    {
        delegate?.endSearchInCell(self)
    }
    func getFrame() -> CGRect {
        return self.frame
    }
    func deleteCell() {
        if tags.count > 0 {
            deleteCell(index: [0, 0])
        }
    }
}

class DropDownMenuTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var tagFieldCollectionView: DynamicHeightCollectionView!
    
    @IBOutlet private weak var titleTextLabel: UILabel!
    @IBOutlet private weak var errorTextLabel: UILabel!
    @IBOutlet private weak var rightImageView: UIImageView!
    
    weak var delegate: DropDownTagConfiguratorDelegate?
    
    private var tags: [String] = []
    private var cellsWidth: [CGFloat] = []
    private var searchItemPath: [IndexPath]!
    
    var isEnableCustomTags: Bool = false// change option for enable/disable customization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func cellInit(title: String, tags: [String], enableCustomTags: Bool) {
        titleTextLabel.text = title
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
        
        let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 0
            tagFieldCollectionView.collectionViewLayout = flowLayout
    }
    
    private func updateCollectionViewLayout() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell})) as! SearchBarCollectionViewCell
        
        if cell.bounds.width >= tagFieldCollectionView.bounds.width * 0.8 {
            return
        }
        tagFieldCollectionView.layoutIfNeeded()
        tagFieldCollectionView.collectionViewLayout.invalidateLayout()
        delegate?.updateFramesInCell(self)
    }

    
    func addCell(newTag: String) {
        if !isEnableCustomTags {
            if tags.contains(newTag) { return }
        }
        if newTag.count <= 2 { return }
        tagFieldCollectionView.performBatchUpdates({
            let indexPath = IndexPath(row: self.tags.count, section: 0)
            tags.append(newTag) //add your object to data source first
            tagFieldCollectionView.insertItems(at: [indexPath])
        })
        updateCollectionViewLayout()
        delegate?.updateFramesInCell(self)
    }
    
    func deleteCell(index: IndexPath) {
        let tag = tags[index.row]
        tagFieldCollectionView.performBatchUpdates({
            tags.remove(at: index.row) //delete your object to data source first
            tagFieldCollectionView.deleteItems(at: [index])
        }, completion: { _ in
            //self.cellDeleteHandler?(tag)
            self.delegate?.cellDelete(tag: tag, self)
        })
        delegate?.updateFramesInCell(self)
    }
    
    private func gestureConfigure() {
        let cell = tagFieldCollectionView.visibleCells.first(where: ({ $0 is SearchBarCollectionViewCell })) as! SearchBarCollectionViewCell
        
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
                guard let self else { return }
//                self.convert(self.frame, to: <#T##UICoordinateSpace#>)
                self.delegate!.startSearchInCell(self)
                self.updateRightIcon(isHidden: true)
            }
            cell.endSearch = { [weak self] in
                guard let self else { return }
                self.updateRightIcon(isHidden: false)
                self.addCell(newTag: cell.getEnters())
//                self.updateCollectionViewLayout()
                self.delegate?.endSearchInCell(self)
            }
            cell.filterResults = { [weak self] in
                self?.updateCollectionViewLayout()
                self?.delegate?.filteringInCell(mask: cell.getEnters())
            }
            return cell
        } else {
            print("<<<<<<<<<<<<ADD CeLL>>>>>>>>>>>>>>")
            let cell = tagFieldCollectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            let tag = tags[indexPath.row]
            cell.cellInit(title: tag)
            //cell.setMaxWidth(width: tagFieldCollectionView.bounds.width-90)
            //updateTagCell(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.tagFieldCollectionView.cellForItem(at: indexPath) is TagCollectionViewCell {
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
