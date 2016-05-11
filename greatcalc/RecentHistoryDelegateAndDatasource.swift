//
//  RecentHistoryDelegateAndDatasource.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/9/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class RecentHistoryDelegateAndDatasource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    var equations = [Equation]()
    
    let equationCell = "EquationCell"
    
    override init() {
        super.init()
        
        if let savedEquations = loadHistory() {
            equations = savedEquations
        }
        var sampleEquation = Equation(operandleft: 2, operandright: 2, operation: CalcOperator.Addition, result: 4, saved: false, active: false)
        equations.append(sampleEquation)
        sampleEquation = Equation(operandleft: 3, operandright: 5, operation: CalcOperator.Addition, result: 8, saved: false, active: false)
        equations.append(sampleEquation)
    }
    
    // NSCoding stuff
    // We're gonna manage the history together here becuase it makes sense.
    // there is literally no other models in this whole app.
    func saveHistory() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(equations, toFile: Equation.ArchiveURL.path!)
        // whatever ¯\_(ツ)_/¯
    }
    
    func loadHistory() -> [Equation]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Equation.ArchiveURL.path!) as? [Equation]
    }
    
    // MARK: Delegate
    
    // MARK: Datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return equations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(equationCell, forIndexPath: indexPath) as! EquationCell
        cell.changeEquation(equations[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(48.0)
    }
    
}

extension RecentHistoryDelegateAndDatasource: EquationCellDelegate {

    // delete her
    func cellDidPullLeftAtIndex(atIndex indexPath: NSIndexPath) {

    }
    
    // save him!
    func cellDidPullRightAtIndex(atIndex indexPath: NSIndexPath) {

    }
    
}

