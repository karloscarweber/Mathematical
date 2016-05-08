//
//  UIKitExtensions.swift
//  greatcalc
//
//  Created by Karl Weber on 5/7/16.
//  Copyright © 2016 Prologue. All rights reserved.
//

import UIKit


extension UIColor {

    // #66727C
    class func mathLightBlack() -> UIColor {
        return UIColor(red: 102/255, green: 114/255, blue: 124/255, alpha: 1.0)
    }
    
    // #30373C
    class func mathDarkBlack() -> UIColor {
        return UIColor(red: 48/255, green: 55/255, blue: 60/255, alpha: 1.0)
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


class MathButton: UIButton {


}



