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
    
    // keyboard components
    let keyboard = KeyboardViewController()
    var originalPoint = CGPointZero // used for animations
    var maximumTravel: CGFloat = 0 // the maximum distance the views can travel downward.
    
    // historyViewComponents
    let historyView = HistoryViewController()
    var historyOriginalPoint = CGPointZero // used for animations
    
    // State management:
    var historyVisible = false
    
    // values
    var operand: Float = 0 // the current operand that is being manipulated
    var opoerandPositivity: Positivity = .Positive
    var storedoperand: Float = 0 // the left hand side of the operator
    
    
    // equation sequences
    /*
     The idea is that we push operations and operands and results in order
     so any input would set the digits, and any operation would create a result.
     We can branch predict what to do based on past results.
     much more predictable.
     */
    // new values
    var operandleft: Float = 0 // the current operand that is being manipulated
    var activeOperator = CalcOperator.Equality // Equality is the default because it does nothing unless tapped.
    var operandright: Float = 0 // the current operand that is being manipulated
    var lastEquation = Equation.blank() // where we're gonna get the result
    
    // panning stuff
    var panner: DiscretePanGestureRecognizer?
    var panner2: DiscretePanGestureRecognizer?
    let gradientBackgroundThingy = GradientView(colorOne: UIColor.mathLightBlack(), colorTwo: UIColor.mathDarkBlack())
    
    // configure views
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
//        panner = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
//        panner2 = DiscretePanGestureRecognizer(direction: .Vertical, target: self, action: #selector(dragged))
//        aScreen.view.addGestureRecognizer(panner!)
//        keyboard.view.addGestureRecognizer(panner2!)
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
            
            operandright = (aScreen.digitField.text?.floatValue)!
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
        operandright = (aScreen.digitField.text?.floatValue)!
        
    }
    
    func clear() {
        
        lastEquation = Equation.blank() // blankedyblank
        // reset fields
        aScreen.digitField.text = "0"
        aScreen.formulaField.text = lastEquation.displayText()
    }
    
    func reversePositivity() {
        
    }

    // receive operations here
    func sendOperation(operation: CalcOperator) {
        
        if lastEquation.result != nil {
            // we had a complete equation last time
            // we'll probably do math
        
            // we have digits
            if ( (aScreen.digitField.text?.floatValue) != 0 ) {
                // the last operation is complete and we have new input
                // this is great, it means that we get to do math right off the bat
                
                if  operation != .Equality {
                    lastEquation = Equation.blank()
                    lastEquation.operandleft = (aScreen.digitField.text?.floatValue)
                    lastEquation.operation = operation
                }
        
            } else {
                
                // it's equality, so it repeats the last equation thing on the result
                if  operation == .Equality {
                    // MARK: lastEquation qualifies to be saved
                    saveLastEquation(lastEquation)
                    
                    lastEquation.operandleft  = lastEquation.result!
                    
                // if it's anything other than an equality
                } else {
                    // MARK: lastEquation qualifies to be saved
                    saveLastEquation(lastEquation)
                    
                    lastEquation.operandleft  = lastEquation.result!
                    lastEquation.operandright = nil
                    lastEquation.operation = operation
                }
                
            }
            changeVisibleNumbersBecauseOfOperations()
            
        } else {
            // the last equation was incomplete we've got to sort things out
            
            // it's all blank back there
            // fresh equation
            if  lastEquation.operandleft == nil &&
                lastEquation.operandright == nil &&
                lastEquation.result == nil &&
                ( (aScreen.digitField.text?.floatValue) != 0 ) {
                
                lastEquation.operandleft = (aScreen.digitField.text?.floatValue)!
                lastEquation.operation = operation
                changeVisibleNumbersBecauseOfOperations()
                return
            }
            
            
            if lastEquation.operandleft != nil && operation != .Equality && ( (aScreen.digitField.text?.floatValue) != 0 ) {
                
                // we know that operandright is nil so we can get a result
                // and then set it to nil again
                lastEquation.operandright = (aScreen.digitField.text?.floatValue)
                // MARK: lastEquation qualifies to be saved
                saveLastEquation(lastEquation)
                
                lastEquation.operandleft  = lastEquation.result!
                lastEquation.operandright = nil
                lastEquation.operation = operation
                changeVisibleNumbersBecauseOfOperations()
                return
            }
            
            // if we tap any operation and we have valid input
            if  lastEquation.operandleft != nil &&
                ( (aScreen.digitField.text?.floatValue) != 0 ) {
                
                // complete the equation
                lastEquation.operandright = (aScreen.digitField.text?.floatValue)
                // MARK: lastEquation qualifies to be saved
                saveLastEquation(lastEquation)
                
                changeVisibleNumbersBecauseOfOperations()
                return
            }
            
            // Change the operation
            if ((aScreen.digitField.text?.floatValue)! == 0) &&
               operation != .Equality {
                
                // but we are setting the operation
                lastEquation.operation = operation
                aScreen.formulaField.text = lastEquation.displayText()
                changeVisibleNumbersBecauseOfOperations()
                return
            }
        
        }
        
    }

    func changeVisibleNumbersBecauseOfOperations() {
        aScreen.digitField.text = "0"
        aScreen.formulaField.text = lastEquation.displayText()
    }
    
    func saveLastEquation(equation: Equation) {
        let archivalEquation = equation
        historyView.historyDND.appendNewEquation(archivalEquation)
    }

}

enum Positivity {
    case Positive
    case Negative
}

extension CalcViewController {

    // the panning thingy!
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
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
        historyVisible = true
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y + self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y + self.maximumTravel)
            self.historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y + self.maximumTravel)
        })
        
    }
    
    func showKeyboard() {
        historyVisible = false
        UIView.animateWithDuration(0.2, animations: {
            self.keyboard.view!.center = CGPointMake(self.originalPoint.x, self.originalPoint.y - self.keyboard.view!.frame.height)
            self.aScreen.view!.center = CGPointMake(self.screenOriginalPoint.x, self.screenOriginalPoint.y - self.maximumTravel)
            self.historyView.view!.center = CGPointMake(self.historyOriginalPoint.x, self.historyOriginalPoint.y - self.maximumTravel)
        })
        
    }

}

