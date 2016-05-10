//
//  EquationCell.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/9/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class EquationCell: UICollectionViewCell {
    
    var indexPath: NSIndexPath?
    
    var equation: Equation?
    var panner: DiscretePanGestureRecognizer?
    var pullDirection: swipePanningDirection = swipePanningDirection.Left
    var deleteflag = UIView()
    var deleteflagOriginalPoint = CGPointZero
    var saveflag = UIView()
    var reticle = UIView() // saved reticle
    var reticleOriginalPoint = CGPointZero
    var subreticle = UIView() // saved sub reticle
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
        // delete this next line later
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.15)
        contentView.addSubview(title)
        
        setupReticles()
    }
    
    func setupReticles() {
        reticle.removeFromSuperview()
        reticle.frame = CGRectMake(15, 19, 10, 10)
        reticle.layer.borderColor = UIColor.mathDarkYellow().CGColor
        reticle.layer.borderWidth = 1.0
        reticle.layer.cornerRadius = 5.0
        contentView.addSubview(reticle)
        
        subreticle.removeFromSuperview()
        subreticle.frame = CGRectMake(2, 2, 6, 6)
        subreticle.backgroundColor = UIColor.mathDarkYellow()
        subreticle.layer.cornerRadius = 3.0
        reticle.addSubview(subreticle)
        
        setupFlags()
    }
    
    func setupFlags() {
        
        let bounds = self.contentView.bounds
    
        // start with save flag
        deleteflag.removeFromSuperview()
        deleteflag.frame = CGRectMake(bounds.width + 62, 0, 124, bounds.height)
        deleteflag.backgroundColor = UIColor.mathDarkRed()
        deleteflag.layer.cornerRadius = bounds.height / 2
        contentView.addSubview(deleteflag)
    }
    
    
    // sets the state and display of all of the stuff.
    func changeEquation(equation: Equation) {
        self.equation = equation
        if equation.saved {
            backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.15)
            reticle.layer.opacity = 1.0
        } else {
            backgroundColor = .clearColor()
            reticle.layer.opacity = 0.0
        }
        title.text = equation.displayText()
    }
    
    // restyles all the things.
    override func layoutSubviews() {
        
    }

}

protocol EquationCellDelegate {
    func cellDidPullLeftAtIndex(atIndex indexPath: NSIndexPath)
    func cellDidPullRightAtIndex(atIndex indexPath: NSIndexPath)
}

extension EquationCell {
    
    // the panning thingy!
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let xDistance = gestureRecognizer.translationInView(self.contentView).x
        
        switch gestureRecognizer.state {
        case .Began:

            // save the original point of the thingys so that we can slowly animate.
            self.titleOriginalPoint = title.center
            self.reticleOriginalPoint = reticle.center
            self.deleteflagOriginalPoint = deleteflag.center
            
            // locks in the action to be either left or right, but not both.
            if xDistance > 0 {
                pullDirection = swipePanningDirection.Right
            } else {
                pullDirection = swipePanningDirection.Left
            }
            
            break
        case .Changed:

            let reducedTranslation = (xDistance * 0.7)
            let acceleratedTranslation = (xDistance * 1.4)
            
            if pullDirection == .Right {
                if xDistance > 0  {
                    print("PUll Right")
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                    reticle.center = CGPointMake(self.reticleOriginalPoint.x + reducedTranslation, self.reticleOriginalPoint.y)
                    deleteflag.center = CGPointMake(self.deleteflagOriginalPoint.x + acceleratedTranslation, self.deleteflagOriginalPoint.y)
                }
                
            } else {
                if xDistance < 0 {
                    print("PUll Left")
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                    reticle.center = CGPointMake(self.reticleOriginalPoint.x + reducedTranslation, self.reticleOriginalPoint.y)
                    deleteflag.center = CGPointMake(self.deleteflagOriginalPoint.x + acceleratedTranslation, self.deleteflagOriginalPoint.y)
                    print("xDistance: \(xDistance)")
                }
                
                if xDistance < -100 {
                    // trigger the end
                    gestureRecognizer.enabled = false
                    print("disable the gesture recognizer")
                    resetViewPositionAndTransformations()
                }
                
            }
            break
        case .Ended:
            print("ended!")
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
            self.reticle.center = self.reticleOriginalPoint
            self.deleteflag.center = self.deleteflagOriginalPoint
            self.panner?.enabled = true
        })
    }
    
    func deleteMe() {
        UIView.animateWithDuration(0.2, animations: {
            self.title.center = self.titleOriginalPoint
            self.reticle.center = self.reticleOriginalPoint
            self.deleteflag.center = self.deleteflagOriginalPoint
            self.panner?.enabled = true
        }, completion: { whatever in
        
        })
    }
    
    func saveMe() {
        UIView.animateWithDuration(0.2, animations: {
            self.title.center = self.titleOriginalPoint
            self.reticle.center = self.reticleOriginalPoint
            self.deleteflag.center = self.deleteflagOriginalPoint
            self.panner?.enabled = true
        }, completion: { whatever in
            if let ip = self.indexPath {
                self.delegate?.cellDidPullRightAtIndex(atIndex: ip)
            }
        })
    }
    
}

enum swipePanningDirection {
    case Left
    case Right
}
