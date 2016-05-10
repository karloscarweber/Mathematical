//
//  Models.swift
//  Mathematical!
//
//  Created by Karl Weber on 4/28/16.
//  Copyright © 2016 Prologue. All rights reserved.
//
//  I know what your thinking! Why does a calculator need a model
//  So that we can store equations of course
//

import UIKit

//struct equation {
//    var operand1: Float = 0,
//        operation = CalcOperator.Addition,
//        operand2: Float = 0,
//        result: Float = 0,
//        saved: Bool = false,
//        active: Bool = false
//}

class Equation: NSObject, NSCoding {
    
    var operandleft: Float = 0,
    operandright: Float = 0,
    operation: CalcOperator = .Addition,
    operationstring = "Addition",
    result: Float = 0,
    saved: Bool = false,
    active: Bool = false
    
    struct PropertyKey {
        static let operandleftKey  = "operandleft"
        static let operandrightKey = "operandright"
        static let operationKey    = "operation"
        static let resultKey       = "result"
        static let savedKey        = "saved"
        static let activeKey       = "active"
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("equations")
    
    init(operandleft: Float, operandright: Float, operation: CalcOperator, result: Float, saved: Bool, active: Bool) {
        self.operandleft = operandleft
        self.operandright = operandright
        self.operation = operation
        self.result = result
        self.saved = saved
        self.active = active
    }
    
    // convenience method
    func displayText() -> String {
        return "\(operandleft.calcValue) \(operatorToString(operation)) \(operandright.calcValue) = \(result.calcValue)"
    }

    // NSCoding stuff for saving files to disk
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(operandleft, forKey: PropertyKey.operandleftKey)
        aCoder.encodeFloat(operandright, forKey: PropertyKey.operandrightKey)
        aCoder.encodeObject(operationstring, forKey: PropertyKey.operationKey)
        aCoder.encodeFloat(result, forKey: PropertyKey.resultKey)
        aCoder.encodeBool(saved, forKey: PropertyKey.savedKey)
        aCoder.encodeBool(active, forKey: PropertyKey.activeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let operandleft = aDecoder.decodeFloatForKey(PropertyKey.operandleftKey)
        let operandright = aDecoder.decodeFloatForKey(PropertyKey.operandrightKey)
        let operationstring = aDecoder.decodeObjectForKey(PropertyKey.operationKey) as! String
        let result = aDecoder.decodeFloatForKey(PropertyKey.resultKey)
        let saved = aDecoder.decodeBoolForKey(PropertyKey.savedKey)
        let active = aDecoder.decodeBoolForKey(PropertyKey.activeKey)
        
        var operation = CalcOperator.Addition
        switch operationstring {
        case "Addition":
            operation = CalcOperator.Addition
        case "Subtraction":
            operation = CalcOperator.Subtraction
        case "Multiplication":
            operation = CalcOperator.Multiplication
        case "Division":
            operation = CalcOperator.Division
        default:
            operation = CalcOperator.Addition
            break
        }
        self.init(operandleft: operandleft, operandright: operandright, operation: operation, result: result, saved: saved, active: active)
    }
    
    func operatorToString(op: CalcOperator) -> String {
        switch op {
        case .Addition:
            return "+"
        case .Subtraction:
            return "-"
        case .Multiplication:
            return "x"
        case .Division:
            return "/"
        default:
            return "+"
        }
        
    }
    
}
