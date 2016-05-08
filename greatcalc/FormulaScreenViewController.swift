//
//  ScreenViewController.swift
//  greatcalc
//
//  Created by Karl Weber on 5/6/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class FormulaScreenViewController: UIViewController {

    var parentCalculator: CalcViewController?
    
    // sizes
    let bounds = UIScreen.mainScreen().bounds
    let margin: CGFloat = 20.0
    let buttonSize: CGFloat = ((UIScreen.mainScreen().bounds.width) / 4)
    let line = UIView()
//    let gradientBackgroundThingy = GradientView(colorOne: UIColor.mathLightBlack(), colorTwo: UIColor.mathDarkBlack())
    
    // views
    let formulaField = UILabel() // where the formula goes.
    let digitField = UILabel() // where the digits go when we tappity tap.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        
        // makes it the size of the space between the keyboard and the top of the screen.
        view.frame = CGRectMake(0, 0, bounds.width, (bounds.height - (buttonSize*5)) )
        view.backgroundColor = .blueColor()
//        setupGradientBackground()
    }
    
    func setupDigitField() {
        let digitYOffset = (bounds.height - (buttonSize*5) - margin - 64)
        digitField.removeFromSuperview()
        digitField.frame = CGRectMake(20.0, digitYOffset, bounds.width - (margin*2), 64.0)
        digitField.font = UIFont.systemFontOfSize(64)
        digitField.textColor = .whiteColor()
        digitField.textAlignment = .Right
        self.view.addSubview(digitField)
        setupFormulaField()
    }
    
    func setupFormulaField() {
        let formulaYOffset = (digitField.frame.origin.y - 2 - 24)
        formulaField.removeFromSuperview()
        formulaField.frame = CGRectMake(20.0, formulaYOffset, bounds.width - (margin*2), 24.0)
        formulaField.font = UIFont.systemFontOfSize(64)
        formulaField.textColor = .whiteColor()
        formulaField.textAlignment = .Right
        formulaField.layer.opacity = 0.3
        self.view.addSubview(formulaField)
        setupLine()
    }
    
    func setupLine() {
        line.removeFromSuperview()
        line.frame = CGRectMake(0, 0, bounds.width, 1.0)
        line.backgroundColor = UIColor.whiteColor()
        line.layer.opacity = 0.2
        self.view.addSubview(line)
//        setupGradientBackground()
    }
    
//    func setupGradientBackground() {
//        gradientBackgroundThingy.removeFromSuperview()
//        gradientBackgroundThingy.frame = CGRectMake(0, 0, bounds.width, bounds.height)
//        
//        self.view.addSubview(gradientBackgroundThingy)
//    
//    }
    
}
