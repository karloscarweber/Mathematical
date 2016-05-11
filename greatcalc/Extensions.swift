//
//  UIKitExtensions.swift
//  Mathematical!
//
//  Created by Karl Weber on 5/7/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit

extension Float {
    var stringValue: String {
        if self - Float(Int(self)) == 0 {
            return "\(Int(self))"
        }
        return "\(self)"
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension UIColor {

    // #66727C
    class func mathLightBlack() -> UIColor {
        return UIColor(red: 102/255, green: 114/255, blue: 124/255, alpha: 1.0)
    }
    
    // #30373C
    class func mathDarkBlack() -> UIColor {
        return UIColor(red: 48/255, green: 55/255, blue: 60/255, alpha: 1.0)
    }
    
    // #979797
    class func mathLightGray() -> UIColor {
        return UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0)
    }
    
    // #818181
    class func mathGray() -> UIColor {
        return UIColor(red: 129/255, green: 129/255, blue: 129/255, alpha: 1.0)
    }
    
    // #FFC600
    class func mathLightYellow() -> UIColor {
        return UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1.0)
    }
    
    // #FFAE00
    class func mathDarkYellow() -> UIColor {
        return UIColor(red: 255/255, green: 174/255, blue: 0/255, alpha: 1.0)
    }
    
    // #D34333
    class func mathDarkRed() -> UIColor {
        return UIColor(red: 211/255, green: 67/255, blue: 51/255, alpha: 1.0)
    }

}

class GradientView: UIView {
    
    var color1 = UIColor.mathLightBlack()
    var color2 = UIColor.mathDarkBlack()
    
    convenience init(colorOne:UIColor, colorTwo: UIColor) {
        self.init(frame:CGRectZero)
        color1 = colorOne
        color2 = colorTwo
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [color1.CGColor, color2.CGColor]
        gradient.startPoint = CGPointZero
        gradient.endPoint = CGPointMake(1, 1);
        layer.addSublayer(gradient)
    }

}

// Math buttons have certain styles that are just fantastic.
class MathButton: UIButton {

    var topLine = false
    var rightLine = false
    var bottomLine = false
    var leftLine = false
    
    var topLineView = UIView()
    var rightLineView = UIView()
    var bottomLineView = UIView()
    var leftLineView = UIView()
    
    var linescolor = UIColor.clearColor()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setupLines()
    }
    
    override func layoutSubviews() {
        setupLines()
        super.layoutSubviews()
    }
    
    func setupLines() {
    
        if topLine == true {
            topLineView.frame = CGRectMake(0, 0, self.frame.width, 1.0)
            topLineView.backgroundColor = linescolor
            addSubview(topLineView)
//            sendSubviewToBack(topLineView)
        } else {
            topLineView.removeFromSuperview()
        }
        
        if rightLine == true {
            rightLineView.frame = CGRectMake(self.frame.width - 1.0, 0, 1.0, self.frame.height)
            rightLineView.backgroundColor = linescolor
            addSubview(rightLineView)
        } else {
            rightLineView.removeFromSuperview()
        }
        
        if bottomLine == true {
            bottomLineView.frame = CGRectMake(0, self.frame.height - 1.0, self.frame.width, 1.0)
            bottomLineView.backgroundColor = linescolor
            addSubview(bottomLineView)
        } else {
            bottomLineView.removeFromSuperview()
        }
        
        if leftLine == true {
            leftLineView.frame = CGRectMake(0, 0, 1.0, self.frame.height)
            leftLineView.backgroundColor = linescolor
            addSubview(leftLineView)
        } else {
            leftLineView.removeFromSuperview()
        }
    
    }
    

}



