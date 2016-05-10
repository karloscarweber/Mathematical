//
//  RecentHistoryDelegateAndDatasource.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/9/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class RecentHistoryDelegateAndDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var equationStorage: HistoryViewController?
    let equationCell = "EquationCell"
    
    // MARK: Delegate
    
    
    // MARK: Datasource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(equationCell, forIndexPath: indexPath) as! EquationCell
        if let storage = equationStorage {
            cell.changeEquation(storage.equations[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(48.0)
    }
    
}

extension RecentHistoryDelegateAndDatasource: EquationCellDelegate {

    
    func cellDidSwipeLeftAtIndex(atIndex indexPath: NSIndexPath) {
        
    }
    
    
    func cellDidSwipeRighAtIndex(atIndex indexPath: NSIndexPath) {
    
    }
    
    
}


