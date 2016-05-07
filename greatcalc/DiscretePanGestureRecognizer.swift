//
//  DiscretePanGestureRecognizer.swift
//  greatcalc
//
//  Created by Karl Weber on 5/6/16.
//  Copyright © 2016 Prologue. All rights reserved.
//
// lifted from: http://stackoverflow.com/questions/7100884/uipangesturerecognizer-only-vertical-or-horizontal
// which is a pretty damn good example if I do say so myself.
// I kid you not I coded something super similar to this but this is better.

import UIKit
import UIKit.UIGestureRecognizerSubclass

enum PanDirection {
    case Vertical
    case Horizontial
}

class DiscretePanGestureRecognizer: UIPanGestureRecognizer {
    
    var direction: PanDirection = .Vertical
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        if state == .Began {
            let velocity = velocityInView(self.view!)
            switch direction {
            case .Horizontial where fabs(velocity.y) > fabs(velocity.x):
                state = .Cancelled
            case .Vertical where fabs(velocity.x) > fabs(velocity.y):
                state = .Cancelled
            default:
                break
            }
        }
    }
    
}




