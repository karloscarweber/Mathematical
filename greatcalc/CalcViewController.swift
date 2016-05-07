//
//  CalcViewController.swift
//  greatcalc
//
//  Created by Karl Weber on 4/27/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {
    
    // sizes
    let bounds = UIScreen.mainScreen().bounds
    let margin: CGFloat = 10.0
    
    // View Screen components
    let screen = ScreenViewController()
    var screenOriginalPoint = CGPointZero // used for animations
    var screenWhereItShouldBePoint = CGPointZero // used for animating it back to where it should be
    
    // interface components
    let keyboard = KeyboardViewController()
    var originalPoint = CGPointZero // used for animations
    var whereItShouldBePoint = CGPointZero // used for animating it back to where it should be
    var maximumTravel: CGFloat = 0 // the maximum distance the views can travel downward.
    let formulaField = UILabel()
    
    
    // State management:
    var historyVisible = false
    
    
    // values
    var operand: Int = 0 // the current operand that is being manipulated
    var poerandPositivity: Positivity = .Positive
    var storedoperand: Int = 0 // the left hand side of the operator
    var activeOperator = CalcOperator.Equality // Equality is the default because it does nothing unless tapped.
    
    var panner: DiscretePanGestureRecognizer?
    
    // states
    
    // no input -> adding input // zero is always the assumed input
    // tapped an operator -> stores the operand into storedoperand // stores the input as operand1 and the operator as the operator
    // tap equal -> replace the operand with the result of the equation and then clear the equation.
    
    
    // initial view setup.
//    override func loadView() {
//
//    }
    
    // configure views again if you need to
    // like if you load from a Nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 48.0, green: 55.0, blue: 60.0, alpha: 1.0) // #30373C

        
        // gesture stuff
        panner = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
        self.view.addGestureRecognizer(panner!)
        
        // layout screen View.
        addChildViewController(screen)
        view.addSubview(keyboard.view)
        
        // layout keyboard view on initial load thing
        addChildViewController(keyboard)
        view.addSubview(keyboard.view)
        keyboard.view.frame = CGRectMake(keyboard.view.frame.origin.x, bounds.height - keyboard.view.frame.height, keyboard.view.frame.width, keyboard.view.frame.height)
        maximumTravel = keyboard.view.frame.height
        layoutFormulaField()
    }
    
    // add the formula field
    func layoutFormulaField() {
        formulaField.frame = CGRectMake(margin, keyboard.view.frame.origin.y - 90.0, keyboard.view.frame.width - margin - margin, 90.0)
        formulaField.text = ""
        addDigit(0)
        formulaField.font = UIFont.systemFontOfSize(80, weight: 0.05)
        formulaField.textAlignment = .Right
        formulaField.textColor = .blueColor()
        view.addSubview(formulaField)
    }
    
    func sendInput(input: Int) {
        addDigit(input)
    }
    
    func sendOperation(operation: CalcOperator) {
        
        print("sendOperation was received: \(operation)")
        switch operation {
        case .Equality:
            resolveEquation()
        default:
            replaceOperator(operation)
            break
        }
        
    }
    
    func sendAction(action: CalcActions) {
        
        switch action {
        case .Backspace:
            backspace()
        case .Clear:
            clear()
        case .PositiveNegative:
            reversePositivity()
        default:
            break
        }
        
    }
    
    // add values
    func addDigit(digit: Int) {
        
        if formulaField.text?.characters.count != 9 {
            if operand == 0 {
                formulaField.text = "\(digit)" // adds the digit
            } else {
                formulaField.text = "\(formulaField.text!)\(digit)" // adds the digit
            }
            
            // we don't actually need to store the operand until we are gonna compute stuff. 
            operand = Int((formulaField.text! as NSString).intValue) // stores the float value
        }
    }
    
    // this happens when we type an operator, it replaces the active
    func replaceOperator(operation: CalcOperator) {
        activeOperator = operation
        storedoperand = operand
        operand = 0
        formulaField.text = "0"
    }
    
    func resolveEquation() {
        
        switch activeOperator {
        case .Addition:
            add()
        case .Subtraction:
            subtract()
        case .Multiplication:
            multiply()
        case .Division:
            divide()
        default:
            break
        }
    }
    
    // Actions
    func backspace() {
        var theText = formulaField.text!
        if theText.characters.count > 0 {
            theText = theText.substringToIndex(theText.startIndex.advancedBy(theText.characters.count - 1))
            formulaField.text = theText
            operand = Int((formulaField.text! as NSString).intValue) // stores the Int value

        }
        
        if theText.characters.count < 1 {
            formulaField.text = "0"
            operand = 0
        }
        
    }
    
    func clear() {
        formulaField.text = "0"
        operand = 0
    }
    
    func reversePositivity() {
        
    }

    
    // perform the actual math
    func add() {
        let result = storedoperand + operand
        formulaField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func subtract() {
        let result = storedoperand - operand
        formulaField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func divide() {
        let result = storedoperand / operand
        formulaField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func multiply() {
        let result = storedoperand * operand
        formulaField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    // utility functions to facilitate behaviours
    /*
        All of the numbers are Floats, but a float is represented with a decimal
        and we don't want decimals at the end if there isn't an actual decimal value
     */
    
    
}


enum Positivity {
    case Positive
    case Negative
}



extension CalcViewController {

    // the panning thingy!
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        print("panning!")
        
        
        let xDistance = gestureRecognizer.translationInView(self.view).x
        let yDistance = gestureRecognizer.translationInView(self.view).y
        let bounds = UIScreen.mainScreen().bounds
        
        switch gestureRecognizer.state {
        case .Began:
            self.originalPoint = keyboard.view!.center;
            break
        case .Changed:
            print("x: \(xDistance), y: \(yDistance)")
            
            if historyVisible == false {
                if(yDistance > 0) {
                    keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + yDistance)
                }
            }
            break
        case .Ended:
            if historyVisible == false {
                if (xDistance > (bounds.width / 3)) || (yDistance > (bounds.height / 3)) || (xDistance < -(bounds.width / 3)) || (yDistance < -(bounds.height / 3)){
                    showHistory()
                } else {
                    resetViewPositionAndTransformations()
                }
            }
            break
        default:
            break
        }
        
    }
    
    func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = self.originalPoint
//            self.keyboard.view!.transform = CGAffineTransformMakeRotation(0)
        })
        
    }
    
    func showHistory() {
        whereItShouldBePoint = originalPoint
        historyVisible = true
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + self.keyboard.view!.frame.height + 20)
            //            self.keyboard.view!.transform = CGAffineTransformMakeRotation(0)
        })
        
    }


}

