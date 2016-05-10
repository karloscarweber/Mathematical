//
//  CalcViewController.swift
//  Mathematical!
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
    
    // keyboard components
    let keyboard = KeyboardViewController()
    var originalPoint = CGPointZero // used for animations
    var whereItShouldBePoint = CGPointZero // used for animating it back to where it should be
    var maximumTravel: CGFloat = 0 // the maximum distance the views can travel downward.
    
    // historyViewComponents
    let historyView = HistoryViewController()
    var historyOriginalPoint = CGPointZero // used for animations
    
    
    // State management:
    var historyVisible = false
    
    // values
    var operand: Float = 0 // the current operand that is being manipulated
    var poerandPositivity: Positivity = .Positive
    var storedoperand: Float = 0 // the left hand side of the operator
    var activeOperator = CalcOperator.Equality // Equality is the default because it does nothing unless tapped.
    
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

        setupGradientThingy()
        
        setupHistoryView()
        
        // layout keyboard view on initial load thing
        layoutKeyboard()
        
        // layout screen View.
        addChildViewController(aScreen)
        view.addSubview(aScreen.view)
        
        // gesture stuff
        panner = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
        panner2 = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
        aScreen.view.addGestureRecognizer(panner!)
        keyboard.view.addGestureRecognizer(panner2!)
    }
    
    func setupGradientThingy() {
        gradientBackgroundThingy.removeFromSuperview()
        gradientBackgroundThingy.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        view.addSubview(gradientBackgroundThingy)
    }
    
    func setupHistoryView() {
        historyView.view.removeFromSuperview()
        addChildViewController(historyView)
        view.addSubview(historyView.view)
    }
    
    
    func layoutKeyboard() {
        addChildViewController(keyboard)
        view.addSubview(keyboard.view)
        keyboard.view.frame = CGRectMake(keyboard.view.frame.origin.x, bounds.height - keyboard.view.frame.height, keyboard.view.frame.width, keyboard.view.frame.height)
        maximumTravel = keyboard.view.frame.height
    }
    
    // digital input
    func sendInput(input: String) {
        
        // we're not at our limit we can add input
        if aScreen.digitField.text?.characters.count != 9 {
            if aScreen.digitField.text != "0" {
                // check for dots
                if (input == ".") && (aScreen.digitField.text?.rangeOfString(".") != nil) {
                    aScreen.digitField.text = "\(aScreen.digitField.text!)" // adds the digit
                } else {
                    aScreen.digitField.text = "\(aScreen.digitField.text!)\(input)" // adds the digit
                }
            } else {
                aScreen.digitField.text = "\(input)" // adds the digit
            }
        }
    }
    
    // Actions!
    func sendAction(action: CalcActions) {
        
        switch action {
        case .Backspace:
            backspace()
        case .Clear:
            clear()
        case .PositiveNegative:
            reversePositivity()
        }
        
    }
    
    func backspace() {
        
        var theText = aScreen.digitField.text!
        if theText.characters.count > 0 {
            theText = theText.substringToIndex(theText.startIndex.advancedBy(theText.characters.count - 1))
            aScreen.digitField.text = theText
        }
        
        if theText.characters.count < 1 {
            aScreen.digitField.text = "0"
        }
        
    }
    
    func clear() {
        aScreen.digitField.text = "0"
    }
    
    func reversePositivity() {
        
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
    
    // this happens when we type an operator, it replaces the active
    func replaceOperator(operation: CalcOperator) {
        activeOperator = operation
        storedoperand = operand
        operand = 0
        aScreen.digitField.text = "0"
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
    
    // perform the actual math
    func add() {
        let result = storedoperand + operand
        aScreen.digitField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func subtract() {
        let result = storedoperand - operand
        aScreen.digitField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func divide() {
        let result = storedoperand / operand
        aScreen.digitField.text = "\(result)"
        operand = result
        storedoperand = 0
    }
    
    func multiply() {
        let result = storedoperand * operand
        aScreen.digitField.text = "\(result)"
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
            self.historyOriginalPoint = historyView.view!.center
            break
        case .Changed:
            print("x: \(xDistance), y: \(yDistance)")
            
            if historyVisible == false {
                if(yDistance > 0) {
                    keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + yDistance)
                    aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + yDistance)
                    historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y + yDistance)
                }
            } else {
                if(yDistance < 0) {
                    keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + yDistance)
                    aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + yDistance)
                    historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y + yDistance)
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
            self.historyView.view!.center = self.historyOriginalPoint
        })
        
    }
    
    func showHistory() {
//        whereItShouldBePoint = originalPoint
        historyVisible = true
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + self.maximumTravel)
            self.historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y + self.maximumTravel)
        })
        
    }
    
    func showKeyboard() {
        //        whereItShouldBePoint = originalPoint
        historyVisible = false
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y - self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y - self.maximumTravel)
            self.historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y - self.maximumTravel)
        })
        
    }

}

