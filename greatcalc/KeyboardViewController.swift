//
//  KeyboardViewController.swift
//  greatcalc
//
//  Created by Karl Weber on 4/27/16.
//  Copyright © 2016 Prologue. All rights reserved.
//
//
//  The Keyboard Controller has all the buttons.
//  We have to respond to a lot of stuf so it's put into this thing.
//


import UIKit

class KeyboardViewController: UIViewController {
    
    var buttons = [Int:UIButton]()
    var parentCalculator: CalcViewController?
    
    
    // sizes
    let bounds = UIScreen.mainScreen().bounds
    let margin: CGFloat = 10.0
    let buttonSize: CGFloat = ((UIScreen.mainScreen().bounds.width - (10.0 * 5)) / 4)
//    let wideButtonSize: CGFloat = (buttonSize * 2) + margin
    
    override func loadView() {
        
        let rootView = UIView()
        
        rootView.frame = CGRectMake(0, 0, bounds.width, ((buttonSize*5) + (margin*6)))
        
        // 19 buttons
        
        // button 0 <-
        let button0 = UIButton()
        button0.frame = CGRectMake(xforbutton(0), yforrow(0), buttonSize, buttonSize)
        button0.setTitle("<-", forState: .Normal)
        button0.tag = 0
        button0.addTarget(self, action: #selector(actionTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button0)
        buttons[0] = button0
        
        
        // button 1 AC
        var button = UIButton()
        button.frame = CGRectMake(xforbutton(1), yforrow(0), buttonSize, buttonSize)
        button.setTitle("AC", forState: .Normal)
        button.tag = 1
        button.addTarget(self, action: #selector(actionTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[1] = button
        
        
        // button 2 +/-
        button = UIButton()
        button.frame = CGRectMake(xforbutton(2), yforrow(0), buttonSize, buttonSize)
        button.setTitle("+/-", forState: .Normal)
        button.tag = 2
        button.addTarget(self, action: #selector(actionTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[2] = button
        
        // button 3 / an operator
        button = UIButton()
        button.frame = CGRectMake(xforbutton(3), yforrow(0), buttonSize, buttonSize)
        button.setTitle("/", forState: .Normal)
        button.tag = 3
        button.addTarget(self, action: #selector(operatorTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[3] = button
        
        // button 4 7
        button = UIButton()
        button.frame = CGRectMake(xforbutton(0), yforrow(1), buttonSize, buttonSize)
        button.setTitle("7", forState: .Normal)
        button.tag = 4
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[4] = button
        
        // button 5 8
        button = UIButton()
        button.frame = CGRectMake(xforbutton(1), yforrow(1), buttonSize, buttonSize)
        button.setTitle("8", forState: .Normal)
        button.tag = 5
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[5] = button
        
        // button 6 9
        button = UIButton()
        button.frame = CGRectMake(xforbutton(2), yforrow(1), buttonSize, buttonSize)
        button.setTitle("9", forState: .Normal)
        button.tag = 6
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[6] = button
        
        // button 7 X an operator
        button = UIButton()
        button.frame = CGRectMake(xforbutton(3), yforrow(1), buttonSize, buttonSize)
        button.setTitle("X", forState: .Normal)
        button.tag = 7
        button.addTarget(self, action: #selector(operatorTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[7] = button
        
        // button 8 4
        button = UIButton()
        button.frame = CGRectMake(xforbutton(0), yforrow(2), buttonSize, buttonSize)
        button.setTitle("4", forState: .Normal)
        button.tag = 8
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[8] = button
        
        // button 9 5
        button = UIButton()
        button.frame = CGRectMake(xforbutton(1), yforrow(2), buttonSize, buttonSize)
        button.setTitle("5", forState: .Normal)
        button.tag = 9
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[9] = button
        
        // button 10 6
        button = UIButton()
        button.frame = CGRectMake(xforbutton(2), yforrow(2), buttonSize, buttonSize)
        button.setTitle("6", forState: .Normal)
        button.tag = 10
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[10] = button
        
        // button 11 X an operator
        button = UIButton()
        button.frame = CGRectMake(xforbutton(3), yforrow(2), buttonSize, buttonSize)
        button.setTitle("-", forState: .Normal)
        button.tag = 11
        button.addTarget(self, action: #selector(operatorTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[11] = button
        
        // button 12 1
        button = UIButton()
        button.frame = CGRectMake(xforbutton(0), yforrow(3), buttonSize, buttonSize)
        button.setTitle("1", forState: .Normal)
        button.tag = 12
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[12] = button
        
        // button 13 2
        button = UIButton()
        button.frame = CGRectMake(xforbutton(1), yforrow(3), buttonSize, buttonSize)
        button.setTitle("2", forState: .Normal)
        button.tag = 13
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[13] = button
        
        // button 14 3
        button = UIButton()
        button.frame = CGRectMake(xforbutton(2), yforrow(3), buttonSize, buttonSize)
        button.setTitle("3", forState: .Normal)
        button.tag = 14
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[14] = button
        
        // button 15 + an operator
        button = UIButton()
        button.frame = CGRectMake(xforbutton(3), yforrow(3), buttonSize, buttonSize)
        button.setTitle("+", forState: .Normal)
        button.tag = 15
        button.addTarget(self, action: #selector(operatorTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[15] = button
        
        // button 16 0
        button = UIButton()
        button.frame = CGRectMake(xforbutton(0), yforrow(4), buttonSize+margin+buttonSize, buttonSize)
        button.setTitle("0", forState: .Normal)
        button.tag = 16
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[16] = button
        
        // button 17 .
        button = UIButton()
        button.frame = CGRectMake(xforbutton(2), yforrow(4), buttonSize, buttonSize)
        button.setTitle(".", forState: .Normal)
        button.tag = 17
        button.addTarget(self, action: #selector(valueTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[17] = button
        
        // button 18 = an operator
        button = UIButton()
        button.frame = CGRectMake(xforbutton(3), yforrow(4), buttonSize, buttonSize)
        button.setTitle("=", forState: .Normal)
        button.tag = 18
        button.addTarget(self, action: #selector(operatorTapped), forControlEvents: .TouchUpInside)
        rootView.addSubview(button)
        buttons[18] = button
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blueColor()
    }
    
    // zero keyed placement. the first button is in place zero.
    func xforbutton(place: CGFloat) -> CGFloat {
        return CGFloat(((buttonSize+margin) * place) + margin)
    }
    
    // zero keyed placement. the first row is in row zero.
    func yforrow(row: CGFloat) -> CGFloat {
        return CGFloat(((buttonSize+margin) * row) + margin)
    }
    
    func valueTapped(sender: UIButton, forEvent event: UIEvent) {
        
        switch sender.tag {
        case 4:
            (parentViewController as! CalcViewController).sendInput(7)
        case 5:
            (parentViewController as! CalcViewController).sendInput(8)
        case 6:
            (parentViewController as! CalcViewController).sendInput(9)
        case 8:
            (parentViewController as! CalcViewController).sendInput(4)
        case 9:
            (parentViewController as! CalcViewController).sendInput(5)
        case 10:
            (parentViewController as! CalcViewController).sendInput(6)
        case 12:
            (parentViewController as! CalcViewController).sendInput(1)
        case 13:
            (parentViewController as! CalcViewController).sendInput(2)
        case 14:
            (parentViewController as! CalcViewController).sendInput(3)
        case 16:
            (parentViewController as! CalcViewController).sendInput(0)
        default:
            break
        }
        
    }
    
    func operatorTapped(sender: UIButton, forEvent event: UIEvent) {
        switch sender.tag {
        case 3:
            (parentViewController as! CalcViewController).sendOperation(CalcOperator.Division)
        case 7:
            (parentViewController as! CalcViewController).sendOperation(CalcOperator.Multiplication)
        case 11:
            (parentViewController as! CalcViewController).sendOperation(CalcOperator.Subtraction)
        case 15:
            (parentViewController as! CalcViewController).sendOperation(CalcOperator.Addition)
        default:
            (parentViewController as! CalcViewController).sendOperation(CalcOperator.Equality)
        }   
    }
    
    func actionTapped(sender: UIButton, forEvent event: UIEvent) {
        
        switch sender.tag {
        case 0:
            (parentViewController as! CalcViewController).sendAction(CalcActions.Backspace)
        case 1:
            (parentViewController as! CalcViewController).sendAction(CalcActions.Clear)
        case 2:
            (parentViewController as! CalcViewController).sendAction(CalcActions.PositiveNegative)
        default:
            break
        }
    }

}
