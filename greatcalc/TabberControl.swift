//
//  TabberControl.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/8/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

class TabberControl: UIViewController {

    let bubble = UIView()
    let buttonLeft = UIButton()
    let buttonRight = UIButton()
    
    var activeButton: TabberButtonPlace = .Left
    
    var delegate: TabberControlDelegate?
    
    // sizes
    var bubbleWidth: CGFloat = 0
    var bubbleHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // makes it the size of the space between the keyboard and the top of the screen.
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 20.0
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.15)
        setupHighlightBubble()
    }
    
    func setupHighlightBubble() {
        
        bubbleHeight = view.frame.height
        bubbleWidth = view.frame.width / 2
        
        bubble.removeFromSuperview()
        bubble.frame = CGRectMake(0, 0, bubbleWidth, bubbleHeight)
        bubble.layer.cornerRadius = 20.0
        bubble.backgroundColor = UIColor(red: 255/255, green: 173/255, blue: 0/255, alpha: 1.0)
        view.addSubview(bubble)
        setupButtons()
    }
    
    func setupButtons() {
        
        buttonLeft.removeFromSuperview()
        buttonLeft.frame = CGRectMake(0, 0, bubbleWidth, bubbleHeight)
        buttonLeft.backgroundColor = .clearColor()
        buttonLeft.setTitle("Recent", forState: .Normal)
        buttonLeft.setTitleColor(.whiteColor(), forState: .Normal)
        buttonLeft.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        buttonLeft.addTarget(self, action: #selector(leftButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(buttonLeft)
        
        
        buttonRight.removeFromSuperview()
        buttonRight.frame = CGRectMake(bubbleWidth, 0, bubbleWidth, bubbleHeight)
        buttonRight.backgroundColor = .clearColor()
        buttonRight.setTitle("Saved", forState: .Normal)
        buttonRight.setTitleColor(.whiteColor(), forState: .Normal)
        buttonRight.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        buttonRight.addTarget(self, action: #selector(rightButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(buttonRight)
    }
    
    func leftButtonTapped() {
        UIView.animateWithDuration(0.2, animations: {
            self.bubble.frame = CGRectMake(0, 0, self.bubbleWidth, self.bubbleHeight)
        })
        delegate?.tabButtonWasTapped(TabberButtonPlace.Left)
    }
    
    func rightButtonTapped() {
        UIView.animateWithDuration(0.2, animations: {
            self.bubble.frame = CGRectMake(self.bubbleWidth, 0, self.bubbleWidth, self.bubbleHeight)
        })
        delegate?.tabButtonWasTapped(TabberButtonPlace.Right)
    }
    
}

protocol TabberControlDelegate {
    func tabButtonWasTapped(place: TabberButtonPlace)
}

enum TabberButtonPlace {
    case Left
    case Right
}
