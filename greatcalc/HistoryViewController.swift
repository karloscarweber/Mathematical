//
//  HistoryViewController.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/8/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

/*
 The HistoryViewcontroller has 2 tableViews. Both are governed by a custom tabber
 above them. The cells are swipeable in two directions triggering a save or delete feature.
 */

class HistoryViewController: UIViewController {
    
    var parentCalculator: CalcViewController?
    
    // sizes
    let bounds = UIScreen.mainScreen().bounds
    let margin: CGFloat = 20.0
    let buttonSize: CGFloat = ((UIScreen.mainScreen().bounds.width) / 4)
    var spaceBetween: CGFloat = 0.0
    
    // views
    let titleLabel = UILabel()
    let customTabber = TabberControl()
    let history = UICollectionView(frame: CGRectZero, collectionViewLayout: DictionaryLayout())
    let historyDND = RecentHistoryDelegateAndDatasource()
//    let saved  = UICollectionView()
//    let savedDND = SavedHistoryDelegateAndDatasource()
    
    // data stuff
    var equations = [Equation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // makes it the size of the space between the keyboard and the top of the screen.
        spaceBetween = (bounds.height - (buttonSize*5))
        view.frame = CGRectMake(0, -(bounds.height - spaceBetween), bounds.width, bounds.height - spaceBetween)
        view.backgroundColor = .clearColor()
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        
        titleLabel.removeFromSuperview()
        titleLabel.frame = CGRectMake(0, margin + margin, bounds.width, 20.0)
        titleLabel.font = UIFont.systemFontOfSize(18)
        titleLabel.textColor = .whiteColor()
        titleLabel.text = "History"
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel)
        setupTabberControl()
    }
    
    func setupTabberControl() {
        
        customTabber.view.removeFromSuperview()
        let positionY = titleLabel.frame.origin.y + titleLabel.frame.height + margin
        customTabber.view.frame = CGRectMake(margin, positionY, bounds.width - margin - margin, 40.0)
        customTabber.viewDidLoad() // I'm pretty sure we don't need to do this.
        view.addSubview(customTabber.view)
        
        setupHistory()
    }
    
    // moves the history to one of these thingys!
    func setupHistory() {
        history.backgroundColor = .clearColor()
        history.delegate = historyDND
        historyDND.parentCollectionView = history
        history.dataSource = historyDND
        history.registerClass(EquationCell.self, forCellWithReuseIdentifier: "EquationCell")
        let positionY = customTabber.view.frame.origin.y + customTabber.view.frame.height + margin
        let height = bounds.height - spaceBetween - positionY
        history.frame = CGRectMake(0, positionY, bounds.width, height)
        print("spaceBetween: \(spaceBetween)")
//        recent.backgroundColor = .clearColor()
        view.addSubview(history)
        setupSaved()
    }
    
    func setupSaved() {
    
    }
    
    func moveToRecent() {
    
    }
    
    func moveToSaved() {
    
    }
    
    // actions
    func saveEquationAtIndex(index: NSIndexPath) {
    
    }
    
    func deleteEquationAtIndex(index: NSIndexPath) {
        
    }
    
    // uses the result of the equation at an index.
    func useEquationAtIndex(index: NSIndexPath) {
        
    }

}
