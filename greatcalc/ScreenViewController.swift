//
//  ScreenViewController.swift
//  greatcalc
//
//  Created by Karl Weber on 5/6/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class ScreenViewController: UIViewController {

    var parentCalculator: CalcViewController?
    
    // sizes
    let bounds = UIScreen.mainScreen().bounds
    let margin: CGFloat = 10.0
    let buttonSize: CGFloat = ((UIScreen.mainScreen().bounds.width) / 4)
    //    let wideButtonSize: CGFloat = (buttonSize * 2) + margin
    
    override func loadView() {
        
        let rootView = UIView()
        // makes it the size of the top thingy.
        rootView.frame = CGRectMake(0, 0, bounds.width, (bounds.height - (buttonSize*5))  )
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueColor()
    }
    
}
