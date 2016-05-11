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
    var parentCollectionView: UICollectionView?
    var viewState: ViewState = .History
    
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
        cell.equation = equations[indexPath.row]
        
//        print("indexPath.row: \(indexPath.row)")
        
        if cell.equation!.saved {
            print("item: \(indexPath.item) is saved")
        }
        cell.matchSavedState()
        cell.changeEquation()
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(48.0)
    }
    
}

extension RecentHistoryDelegateAndDatasource: EquationCellDelegate {

    // delete her
    func cellDidPullLeftAtIndex(atIndex indexPath: NSIndexPath) {
        
        print("DELETE!")
        
        let cellsToDelete = [indexPath]
        
        if (indexPath.item < equations.count) { // protect against folly
            parentCollectionView?.performBatchUpdates({
                self.parentCollectionView?.deleteItemsAtIndexPaths(cellsToDelete)
                self.equations.removeAtIndex(indexPath.item)
                }, completion: { whatever in
                    self.saveHistory()
            })
        }

    }
    
    // save him!
    func cellDidPullRightAtIndex(atIndex indexPath: NSIndexPath) {
        self.saveHistory()
    }
    
}

// Methods for appending a new equation from the CalcViewcontroller
extension RecentHistoryDelegateAndDatasource {
    
    func appendNewEquation(equation: Equation) {
        
        print("appendNewEquation")
    
        // it's too big, must cut the fat first
        if equations.count == 25 {
            
            var ip = NSIndexPath(forItem: 0, inSection: 0)
            var ipset = false
            // cycle through until we have a deleter
            for (index, eq) in equations.enumerate() {
                if eq.saved == false {
                    ipset = true
                    ip = NSIndexPath(forItem: index, inSection: 0)
                    break
                }
            }
            
            // delete them things before adding.
            if ipset {
                cellDidPullLeftAtIndex(atIndex: ip)
            }
            
        }
        
        // if we've still got too many, then tough luck son.
        if equations.count < 25 {
            
            // animate adding this stuff
            if viewState == .Saved {
                self.equations.append(equation)
            } else {
                
                print("self.equations.count: \(self.equations.count)")
                
                // insert stuff here
                parentCollectionView?.performBatchUpdates({
                    self.equations.append(equation) // we append it
                    let cellsToAdd = [NSIndexPath(forItem: (self.equations.count - 1), inSection: 0)]
                    self.parentCollectionView?.insertItemsAtIndexPaths(cellsToAdd)
                }, completion: { whatever in
                    
                })
            }
        }
        self.saveHistory()
    }

}

enum ViewState {
    case History
    case Saved
}
