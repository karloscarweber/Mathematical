//
//  EquationCell.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/9/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class EquationCell: UICollectionViewCell {
    
    var equation: Equation?
    var panner: DiscretePanGestureRecognizer?
    var pullDirection: swipePanningDirection = swipePanningDirection.Left
    var deleteicon = UIView()
    var saveicon = UIView()
    var saved = UIView()
    var title = UILabel()
    var titleOriginalPoint = CGPointZero
    var delegate: EquationCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if panner == nil {
            panner = DiscretePanGestureRecognizer(direction: PanDirection.Horizontial, target: self, action: #selector(dragged))
            contentView.addGestureRecognizer(panner!)
        }
        
        // set up all the amazing things!
        contentView.backgroundColor = .clearColor()
        setupTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTitle() {
        title.removeFromSuperview()
        title.font = UIFont.systemFontOfSize(18)
        title.textAlignment = .Right
        title.textColor = .whiteColor()
        title.frame = CGRectMake(20, 15, (contentView.frame.width - 40.0), 18)
//        title.text = equation?.displayText()
        title.text = "999999999"
        contentView.addSubview(title)
        
        setupReticle()
    }
    
    func setupReticle() {
    
    
    }
    
    
    // sets the state and display of all of the stuff.
    func changeEquation(equation: Equation) {
        self.equation = equation
        if equation.saved {
            backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.15)
        } else {
            backgroundColor = .clearColor()
        }
    }
    
    // restyles all the things.
    override func layoutSubviews() {
        
    }

}

protocol EquationCellDelegate {
    func cellDidSwipeLeftAtIndex(atIndex indexPath: NSIndexPath)
    func cellDidSwipeRighAtIndex(atIndex indexPath: NSIndexPath)
}

extension EquationCell {
    
    // the panning thingy!
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let xDistance = gestureRecognizer.translationInView(self.contentView).x
        let yDistance = gestureRecognizer.translationInView(self.contentView).y
//        let bounds = UIScreen.mainScreen().bounds
        
        
        switch gestureRecognizer.state {
        case .Began:

            // save the original point of the thingys so that we can slowly animate.
            self.titleOriginalPoint = title.center
            
            // locks in the action to be either left or right, but not both.
            if xDistance > 0 {
                pullDirection = swipePanningDirection.Right
            } else {
                pullDirection = swipePanningDirection.Left
            }
            
            break
        case .Changed:
//            print("x: \(xDistance), y: \(yDistance)")
            
            if pullDirection == .Right {
                if(xDistance > 0) {
                    
                    let reducedTranslation = (xDistance * 0.7)
                    
                    print("PUll Right")
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                }
            } else {
                if(xDistance < 0) {
                    let reducedTranslation = (xDistance * 0.7)
                    print("PUll Left")
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                }
            }
            break
        case .Ended:
            if pullDirection == .Right {
//                if  (xDistance > (bounds.width / 3))  ||
//                    (yDistance > (bounds.height / 3)) ||
//                    (xDistance < -(bounds.width / 3)) ||
//                    (yDistance < -(bounds.height / 3)) {
////                    showHistory()
//                } else {
//                    resetViewPositionAndTransformations()
//                }
            } else {
//                if  (xDistance > (bounds.width / 3))  ||
//                    (yDistance > (bounds.height / 3)) ||
//                    (xDistance < -(bounds.width / 3)) ||
//                    (yDistance < -(bounds.height / 3)) {
////                    showKeyboard()
//                } else {
//                    resetViewPositionAndTransformations()
//                }
            }
            resetViewPositionAndTransformations()
            break
        default:
            break
        }
        
    }
    
    func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: {
            self.title.center = self.titleOriginalPoint
        })
        
    }
    
    
}

enum swipePanningDirection {
    case Left
    case Right
}
