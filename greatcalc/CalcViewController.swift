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
    let aScreen = FormulaScreenViewController()
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
    var currentValueMode: ValueMode = .Append
    
    var panner: DiscretePanGestureRecognizer?
    var panner2: DiscretePanGestureRecognizer?
    let gradientBackgroundThingy = GradientView(colorOne: UIColor.mathLightBlack(), colorTwo: UIColor.mathDarkBlack())

    
    // states
    
    // no input -> adding input // zero is always the assumed input
    // tapped an operator -> stores the operand into storedoperand // stores the input as operand1 and the operator as the operator
    // tap equal -> replace the operand with the result of the equation and then clear the equation.
    
    
    // configure views again if you need to
    // like if you load from a Nib.
    override func viewDidLoad() {
        super.viewDidLoad()


        
        gradientBackgroundThingy.removeFromSuperview()
        gradientBackgroundThingy.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        view.addSubview(gradientBackgroundThingy)
        
        // layout keyboard view on initial load thing
        addChildViewController(keyboard)
        view.addSubview(keyboard.view)
        keyboard.view.frame = CGRectMake(keyboard.view.frame.origin.x, bounds.height - keyboard.view.frame.height, keyboard.view.frame.width, keyboard.view.frame.height)
        maximumTravel = keyboard.view.frame.height
        layoutFormulaField()
        
        // layout screen View.
        addChildViewController(aScreen)
        //        print("bounds.width: \(bounds.width), \(bounds.height)")
        //        aScreen.view.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        view.addSubview(aScreen.view)
        
        // gesture stuff
        panner = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
        panner2 = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
        aScreen.view.addGestureRecognizer(panner!)
        keyboard.view.addGestureRecognizer(panner2!)
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
        
        if currentValueMode == ValueMode.Append {
            // if we haven't just pressed the equals sign then add a digit
            addDigit(input)
        } else {
            // else replace the current number with the numbers you type in.
            replaceDigits(input)
        }
        
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
     
        if aScreen.formulaField.text?.characters.count != 9 {
            aScreen.formulaField.text = "\(formulaField.text!)\(digit)" // adds the digit
        }
        
//        if formulaField.text?.characters.count != 9 {
//            formulaField.text = "\(formulaField.text!)\(digit)" // adds the digit
//            // we don't actually need to store the operand until we are gonna compute stuff. 
////            operand = Int((formulaField.text! as NSString).intValue) // stores the float value
//        }
    }
    
    func replaceDigits(digit: Int) {
//        formulaField.text = "\(digit)" // adds the digit
        aScreen.formulaField.text = "\(digit)" // adds the digit
        // we don't actually need to store the operand until we are gonna compute stuff.
//        operand = Int((formulaField.text! as NSString).intValue) // stores the float value
        
        currentValueMode = .Append
    }
    
    // this happens when we type an operator, it replaces the active
    func replaceOperator(operation: CalcOperator) {
        activeOperator = operation
        storedoperand = operand
        operand = 0
//        formulaField.text = "0"
        aScreen.formulaField.text = "0"
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
//        var theText = formulaField.text!
        var theText = aScreen.formulaField.text!
        if theText.characters.count > 0 {
            theText = theText.substringToIndex(theText.startIndex.advancedBy(theText.characters.count - 1))
//            formulaField.text = theText
            aScreen.formulaField.text = theText
//            operand = Int((formulaField.text! as NSString).intValue) // stores the Int value
            operand = Int((aScreen.formulaField.text! as NSString).intValue) // stores the Int value

        }
        
        if theText.characters.count < 1 {
//            formulaField.text = "0"
            aScreen.formulaField.text = "0"
            operand = 0
        }
        
    }
    
    func clear() {
//        formulaField.text = "0"
        aScreen.formulaField.text = "0"
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
            self.originalPoint = keyboard.view!.center
            self.screenOriginalPoint = aScreen.view!.center
            break
        case .Changed:
            print("x: \(xDistance), y: \(yDistance)")
            
            if historyVisible == false {
                if(yDistance > 0) {
                    keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + yDistance)
                    aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + yDistance)
                }
            } else {
                if(yDistance < 0) {
                    keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + yDistance)
                    aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + yDistance)
                }
            }
            break
        case .Ended:
            if historyVisible == false {
                if  (xDistance > (bounds.width / 3))  ||
                    (yDistance > (bounds.height / 3)) ||
                    (xDistance < -(bounds.width / 3)) ||
                    (yDistance < -(bounds.height / 3)) {
                    showHistory()
                } else {
                    resetViewPositionAndTransformations()
                }
            } else {
                if  (xDistance > (bounds.width / 3))  ||
                    (yDistance > (bounds.height / 3)) ||
                    (xDistance < -(bounds.width / 3)) ||
                    (yDistance < -(bounds.height / 3)) {
                    showKeyboard()
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
            self.aScreen.view!.center = self.screenOriginalPoint
//            self.keyboard.view!.transform = CGAffineTransformMakeRotation(0)
        })
        
    }
    
    func showHistory() {
//        whereItShouldBePoint = originalPoint
        historyVisible = true
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + self.keyboard.view!.frame.height)
        })
        
    }
    
    func showKeyboard() {
        //        whereItShouldBePoint = originalPoint
        historyVisible = false
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y - self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y - self.keyboard.view!.frame.height)
        })
        
    }

}

