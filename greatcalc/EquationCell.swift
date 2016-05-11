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
    
    // panner stuff
    var panner: DiscretePanGestureRecognizer?
    var pullDirection: swipePanningDirection = swipePanningDirection.Left
    
    // flags and their positions
    var deleteflag = UIView()
    var deleteflagOriginalPoint = CGPointZero
    var saveflag = UIView()
    var saveflagOriginalPoint = CGPointZero
    
    // reticle badge
    var reticle = UIView() // saved reticle
    var reticleOriginalPoint = CGPointZero
    var subreticle = UIView() // saved sub reticle
    
    // te actual title
    var title = UILabel()
    var titleOriginalPoint = CGPointZero
    
    // delegate
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
        
        let deleteIcon = UIView()
        deleteIcon.backgroundColor = .whiteColor()
        deleteIcon.frame = CGRectMake(20, 17.335, 13.33, 13.33)
        deleteIcon.maskView = UIImageView(image: UIImage.mathMultiply() )
        deleteflag.addSubview(deleteIcon)
        
        saveflag.removeFromSuperview()
        saveflag.frame = CGRectMake( 0 - 62 - 124, 0, 124, bounds.height)
        saveflag.backgroundColor = UIColor.mathDarkGreen()
        saveflag.layer.cornerRadius = bounds.height / 2
        contentView.addSubview(saveflag)
        
        let saveIcon = UIView()
        saveIcon.backgroundColor = .whiteColor()
        saveIcon.frame = CGRectMake(saveflag.frame.width - 28, 17, 14, 14)
        saveIcon.maskView = UIImageView(image: UIImage.mathCheck())
        saveflag.addSubview(saveIcon)
    }
    
    // sets the state and display of all of the stuff.
    func changeEquation() {
        print("changeEquation called")
        UIView.animateWithDuration(0.2, animations: {
            self.matchSavedState()
        }, completion: { whatever in
        })
        title.text = equation!.displayText()
    }
    
    func matchSavedState() {
        if self.equation!.saved {
            self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.15)
            self.reticle.layer.opacity = 1.0
        } else {
            self.backgroundColor = .clearColor()
            self.reticle.layer.opacity = 0.0
        }
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
            self.saveflagOriginalPoint = saveflag.center
            
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
//                    print("PUll Right")
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                    reticle.center = CGPointMake(self.reticleOriginalPoint.x + reducedTranslation, self.reticleOriginalPoint.y)
                    deleteflag.center = CGPointMake(self.deleteflagOriginalPoint.x + acceleratedTranslation, self.deleteflagOriginalPoint.y)
                    saveflag.center = CGPointMake(self.saveflagOriginalPoint.x + acceleratedTranslation, self.saveflagOriginalPoint.y)
                }
                
                if xDistance > 100 {
                    
                    gestureRecognizer.enabled = false
                    
                    // trigger the save / unsave
                    let newEquation = self.equation!
                    if newEquation.saved == true {
                        newEquation.saved = false
                        print("set to unsaved")
                    } else {
                        newEquation.saved = true
                        print("set to saved")
                    }
                    changeEquation()
                    saveMe()
                    resetViewPositionAndTransformations()
                }
                
            } else {
                if xDistance < 0 {
                    title.center = CGPointMake(self.titleOriginalPoint.x + reducedTranslation, self.titleOriginalPoint.y)
                    reticle.center = CGPointMake(self.reticleOriginalPoint.x + reducedTranslation, self.reticleOriginalPoint.y)
                    deleteflag.center = CGPointMake(self.deleteflagOriginalPoint.x + acceleratedTranslation, self.deleteflagOriginalPoint.y)
                    saveflag.center = CGPointMake(self.saveflagOriginalPoint.x + acceleratedTranslation, self.saveflagOriginalPoint.y)
                }
                
                if xDistance < -100 {
                    // trigger the delete
                    gestureRecognizer.enabled = false
                    
                    deleteMe() // deletes the fellow
                    resetViewPositionAndTransformations()
                }
                
            }
            break
        case .Ended:
            // because of the way this gesture recognizer works we're barely using this one.
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
            self.saveflag.center = self.saveflagOriginalPoint
            
        }, completion: { whatever in
            self.panner?.enabled = true
        })
    }
    
    func deleteMe() {
        print("delete me")
        if let ip = self.indexPath {
            self.delegate?.cellDidPullLeftAtIndex(atIndex: ip)
        }
    }
    
    func saveMe() {
        print("save me")
        if let ip = self.indexPath {
            self.delegate?.cellDidPullRightAtIndex(atIndex: ip)
        }
    }
    
}

enum swipePanningDirection {
    case Left
    case Right
}
