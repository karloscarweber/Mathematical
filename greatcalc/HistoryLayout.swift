//
//  HistoryLayout.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/9/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class DictionaryLayout: UICollectionViewLayout {
    
    let cellHeight: CGFloat = 48.0
    
    
    // MARK: Basic Layout Methods to override
    
    // returns the width and height of the collection Views CONTENT
    override func collectionViewContentSize() -> CGSize {
        let contentWidth: CGFloat = self.collectionView!.bounds.size.width
        let total = CGFloat((collectionView!.dataSource?.collectionView(collectionView!, numberOfItemsInSection: 0))!)
        let contentHeight: CGFloat = (cellHeight * total) + 62
        return CGSizeMake(contentWidth, contentHeight)
    }
    
    // Returns the layout attributes for all of the cells and views in the specified rectangle.
    // I would say that A little math here wouldn't hurt.
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var myRect = rect
        
        // always make the rect bigger.
        myRect = CGRectMake(rect.origin.x, 0, rect.width, rect.height + 667)
        
        var attributes = [UICollectionViewLayoutAttributes]()
        
        // find out which cell we are hypothetically starting with.
        var counter: CGFloat = 0
        var startingY: CGFloat = 0
        while counter < myRect.origin.y {
            startingY = counter
            counter = counter + cellHeight
        }
        let iterations = counter / cellHeight
        
        // find the last iteration
        var endCounter: CGFloat = startingY
        let endRectY: CGFloat = myRect.origin.y + myRect.height
        var lastIteration = iterations
        while endCounter < endRectY {
            endCounter = endCounter + cellHeight
        }
        lastIteration = endCounter / cellHeight
        
        // generate the attributes
        let totalitems = CGFloat(collectionView!.numberOfItemsInSection(0))
        var currentIteration = iterations
        var currentY = startingY
        while currentIteration < lastIteration {
            
            // configure the layout attributes using their indexPaths
            if currentIteration < totalitems {
                attributes.append(self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: Int(currentIteration), inSection: 0))!)
            }
            
            currentIteration = currentIteration + 1
            currentY = currentY + cellHeight
        }
        
        return attributes
    }
    
    // Returns the layout attributes for the item at the specified index path.
    // This will probably have a little math too.
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let width: CGFloat = self.collectionView!.bounds.size.width
        
        // determine if it's odd or even
        let xPostion: CGFloat = 0
        var yPostion: CGFloat = 0
        
        if indexPath.item > 0 {
            yPostion = CGFloat(indexPath.item) * cellHeight
        }
        
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        layoutAttribute.frame = CGRectMake(xPostion, yPostion, width, cellHeight)
        return layoutAttribute
    }
    
    // Asks the layout object if the new bounds require a layout update.
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // for Deleting and Adding rows
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let width: CGFloat = self.collectionView!.bounds.size.width
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        layoutAttribute.frame = CGRectMake(0, 0, width, cellHeight)
        layoutAttribute.alpha = 0
        return layoutAttribute
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let width: CGFloat = self.collectionView!.bounds.size.width
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: itemIndexPath)
        layoutAttribute.frame = CGRectMake(-width-100, 0, width, cellHeight)
        layoutAttribute.alpha = 0
        return layoutAttribute
    }
    
}
