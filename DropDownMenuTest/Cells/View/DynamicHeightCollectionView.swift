//
//  DynamicHeightCollectionView.swift
//  DropDownMenuTest
//
//  Created by mac on 12/9/22.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    
    override var contentSize: CGSize{
        didSet {
            if oldValue.height != self.contentSize.height {
                invalidateIntrinsicContentSize()
                print(self.contentSize.height)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: contentSize.height)
    }
}
